import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import { createVuetify } from 'vuetify'
import 'vuetify/styles'
import { aliases, mdi } from 'vuetify/iconsets/mdi'
import * as components from 'vuetify/components'
import * as directives from 'vuetify/directives'
import { createPinia } from 'pinia'
import { syncQueue } from '@config/lokiJS/loki'
import { processQueue } from '@config/lokiJS/syncHelper'

const vuetify = createVuetify({
  components,
  directives,
  icons: {
    defaultSet: 'mdi',
    aliases,
    sets: { mdi }
  },
  theme: {
    defaultTheme: 'dark'
  }
})

export default vuetify

const app = createApp(App)
const pinia = createPinia()

app.use(syncQueue)
app.use(pinia)
app.use(vuetify)
app.use(router)

app.mount('#app')

document.addEventListener('deviceready', onDeviceReady, false)

window.addEventListener('online', () => {
  console.log('Connection restored. Synchronizing data with server...')
  processQueue().then((r) => console.log('Data synchronized with server.'))
})

function onDeviceReady() {
  console.log('Running cordova-' + cordova.platformId + '@' + cordova.version)
  document.getElementById('deviceready').classList.add('ready')
}