import {createApp} from 'vue'
import App from './App.vue'
import router from './router'
import {createVuetify} from 'vuetify'
import 'vuetify/styles'
import {aliases, mdi} from 'vuetify/iconsets/mdi'
import * as components from 'vuetify/components'
import * as directives from 'vuetify/directives'
import {createPinia} from 'pinia'
import {clocksCollection, db, teamsCollection, usersCollection, workingTimesCollection} from './loki.js'

// Configurer Vuetify
const vuetify = createVuetify({
  components,
  directives,
  icons: {
    defaultSet: 'mdi',
    aliases,
    sets: {
      mdi
    }
  }
})

const lokiPlugin = {
  install(app) {
    app.config.globalProperties.$db = db
    app.config.globalProperties.$collections = {
      clocksCollection: clocksCollection,
      teamsCollection: teamsCollection,
      workingTimes: workingTimesCollection,
      users: usersCollection
    }
  }
}

const app = createApp(App)
const pinia = createPinia()

app.use(pinia)
app.use(vuetify)
app.use(router)

app.use(lokiPlugin)

app.mount('#app')

document.addEventListener('deviceready', onDeviceReady, false)

function onDeviceReady() {
  console.log('Running cordova-' + cordova.platformId + '@' + cordova.version)
  document.getElementById('deviceready').classList.add('ready')
}
