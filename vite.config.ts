import tailwindcss from "@tailwindcss/vite";
import { defineConfig } from "vite";
import ViteRails from "vite-plugin-rails";

export default defineConfig({
  plugins: [
    tailwindcss(),
    ViteRails(),
  ],
})
