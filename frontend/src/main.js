import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import { createVuetify } from 'vuetify'
import 'vuetify/styles'
import { aliases, mdi } from 'vuetify/iconsets/mdi'
import * as components from 'vuetify/components'
import * as directives from 'vuetify/directives'
import { createPinia } from 'pinia'
import {
  clocksCollection,
  db,
  logsCollection,
  syncLocalDataWithServer,
  teamsCollection,
  usersCollection,
  workingTimesCollection
} from '@config/loki'

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

app.use(pinia)
app.use(vuetify)
app.use(router)

app.mount('#app')

document.addEventListener('deviceready', onDeviceReady, false)

window.addEventListener('online', () => {
  console.log('Connection restored. Synchronizing data with server...')
  syncLocalDataWithServer()
})

function onDeviceReady() {
  console.log('Running cordova-' + cordova.platformId + '@' + cordova.version)
  document.getElementById('deviceready').classList.add('ready')
}

console.log('LokiJS collections initialized:', {
  usersCollection,
  workingTimesCollection,
  clocksCollection,
  teamsCollection,
  logsCollection
})

db.loadDatabase({}, () => {
  console.log('LokiJS database loaded successfully')
})