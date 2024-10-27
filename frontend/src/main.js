import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import 'vuetify/styles'
import { createPinia } from 'pinia'
import { syncQueue } from '@config/lokiJS/loki'
import { processQueue } from '@config/lokiJS/syncHelper'
import vuetify from '@/plugins/vuetify'
import { useToast } from 'vue-toast-notification'
import 'vue-toast-notification/dist/theme-sugar.css'

const app = createApp(App)
const pinia = createPinia()
const $toast = useToast()

app.use(syncQueue)
app.use(vuetify)
app.use(pinia)
app.use(router)

app.mount('#app')

document.addEventListener('deviceready', onDeviceReady, false)

window.addEventListener('online', () => {
  $toast.info('Connection restored. Synchronizing data with server...', {
    position: 'top-left',
    duration: 2000,
    dismissible: true
  })
  processQueue().then((r) => console.log('Data synchronized with server.'))
})
window.addEventListener('offline', () => {
  $toast.info('Connection lost. Actions made during offline state will be sent on reconnection', {
    position: 'top-left',
    duration: 2000,
    dismissible: true
  })
})

function onDeviceReady() {
  console.log('Running cordova-' + cordova.platformId + '@' + cordova.version)
  document.getElementById('deviceready').classList.add('ready')
}
