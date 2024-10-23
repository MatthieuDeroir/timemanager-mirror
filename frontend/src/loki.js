import Loki from 'lokijs'
import WorkingTimeAPI from '@/api/WorkingTimeAPI'
import UserAPI from '@/api/UserAPI'
import ClockAPI from '@/api/ClockAPI'
import TeamAPI from '@/api/TeamAPI'

/**
 * Init the local database
 * @type {Loki}
 * @name timeManagerDB
 * @description Database to store all the data locally only for web app, using the localstorage is not recommended for mobile apps,
 * with cordova we can use sqlite.
 * @property {boolean} autosave - Save the database automatically
 */
const db = new Loki('timemanagerdb', {
  autosave: true,
  autosaveInterval: 5000,
  persistenceMethod: 'localStorage'
})

// Collection creation, mirror the server database
const usersCollection = db.addCollection('users', { unique: ['id'] })
const workingTimesCollection = db.addCollection('workingTimes', { unique: ['id'] })
const clocksCollection = db.addCollection('clocks', { unique: ['id'] })
const teamsCollection = db.addCollection('teams', { unique: ['id'] })

/**
 * Sync all unsynced changes with the API
 * @param collection
 * @param API
 * @returns {Promise<void>}
 */
const syncCollection = async (collection, API) => {
  try {
    const unsyncedChanges = collection.find({ synced: false })

    for (const change of unsyncedChanges) {
      if (change.action === 'create') {
        await API.create(change)
      } else if (change.action === 'update') {
        console.log('=>(loki.js:41) change', change)
        console.log('=>(loki.js:41) change.action', change.action)
        console.log('=>(loki.js:36) unsyncedChanges', unsyncedChanges)
        console.log('=>(loki.js:59) collection', collection)
        console.log('API', API)
        await API.update(change.id, change)
      } else if (change.action === 'delete') {
        await API.delete(change.id)
      }

      const existing = collection.findOne({ id: change.id })
      if (existing) {
        existing.synced = true
        collection.update(existing)
      }
    }

    console.log(`Synchronisation réussie pour la collection ${collection.name}`)
  } catch (error) {
    console.error(`Erreur lors de la synchronisation de la collection ${collection.name}`, error)
  }
}

const syncAllCollections = () => {
  syncCollection(workingTimesCollection, WorkingTimeAPI)
  syncCollection(usersCollection, UserAPI)
  syncCollection(clocksCollection, ClockAPI)
  syncCollection(teamsCollection, TeamAPI)
}

// Trigger the sync when the app is back online
window.addEventListener('online', syncAllCollections)

export {
  db,
  usersCollection,
  workingTimesCollection,
  clocksCollection,
  teamsCollection,
  syncAllCollections
}
