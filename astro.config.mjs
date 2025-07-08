// astro.config.mjs
import { defineConfig } from 'astro/config';

import tailwindcss from '@tailwindcss/vite';

// Basic config without any integrations first
export default defineConfig({
  output: 'static',

  vite: {
    plugins: [tailwindcss()]
  }
});