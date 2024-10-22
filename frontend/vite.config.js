import { fileURLToPath, URL } from 'node:url';
import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';
import vueDevTools from 'vite-plugin-vue-devtools';
import path from 'path';

export default defineConfig({
  plugins: [vue(), vueDevTools()],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url)),
      '@components': fileURLToPath(new URL('./src/components', import.meta.url)),
      '@views': fileURLToPath(new URL('./src/views', import.meta.url)),
      '@assets': fileURLToPath(new URL('./src/assets', import.meta.url)),
      '@router': fileURLToPath(new URL('./src/router', import.meta.url)),
      '@api': fileURLToPath(new URL('./src/services', import.meta.url)),
      '@utils': fileURLToPath(new URL('./src/utils', import.meta.url)),
      '@dto': fileURLToPath(new URL('./src/dto', import.meta.url)),
      '@composables': fileURLToPath(new URL('./src/composables', import.meta.url)),
      '@store': fileURLToPath(new URL('./src/store', import.meta.url)),
      '@enum': fileURLToPath(new URL('./src/enum', import.meta.url)),
      '@styles': fileURLToPath(new URL('./src/styles', import.meta.url))
    }
  },
  build: {
    outDir: path.resolve(__dirname, './gothamTimeManagerPhoneApp/www'),
    emptyOutDir: true // This will clear the `www` folder before building
  }
});
