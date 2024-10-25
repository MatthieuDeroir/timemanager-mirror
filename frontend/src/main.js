import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import 'vuetify/styles'
import { createPinia } from 'pinia'
import { syncQueue } from '@config/lokiJS/loki'
import { processQueue } from '@config/lokiJS/syncHelper'
import vuetify from '@/plugins/vuetify'

const app = createApp(App)
const pinia = createPinia()

app.use(syncQueue)
app.use(vuetify)
app.use(pinia)
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
