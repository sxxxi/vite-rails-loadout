class User < ApplicationRecord
  has_secure_password reset_token: { expires_in: 24.hours }, validations: true
end
