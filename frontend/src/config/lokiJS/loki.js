import Loki from 'lokijs'

const db = new Loki('timeanagerQueue', {
  autosave: true,
  autosaveInterval: 5000,
  persistenceMethod: 'localStorage'
})

const syncQueue = db.getCollection('syncQueue') || db.addCollection('syncQueue', { unique: ['id'] })

export { db, syncQueue }
