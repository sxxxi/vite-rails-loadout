ARG RUBY_VERSION=3.4.7

FROM oven/bun:latest AS js-build
WORKDIR /js
COPY package.json bun.lock ./
RUN bun install

FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base
WORKDIR /rails

# Install base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y unzip curl libjemalloc2 libvips sqlite3 && \
    ln -s /usr/lib/$(uname -m)-linux-gnu/libjemalloc.so.2 /usr/local/lib/libjemalloc.so && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives && \
    curl -fsSL https://bun.sh/install | BUN_INSTALL=/usr bash && \
    bun install -g foreman

ENV RAILS_ENV="development" \
    VITE_RUBY_HOST=0.0.0.0 \
    BUNDLE_PATH="/usr/local/bundle"

FROM base AS build
# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libyaml-dev pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives
COPY vendor/* ./vendor/
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git
COPY . .


# Final stage for app image
FROM base
# Run and own only the runtime files as a non-root user for security
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash
USER 1000:1000
# Copy built artifacts: gems, application
COPY --chown=rails:rails --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --chown=rails:rails --from=build /rails /rails
COPY --chown=rails:rails --from=js-build /js/node_modules /rails/node_modules
EXPOSE 3000
EXPOSE 3036
# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]
CMD ["bunx", "foreman", "start", "--procfile=Procfile.dev"]
