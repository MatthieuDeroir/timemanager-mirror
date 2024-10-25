import Loki from 'lokijs'
import UserAPI from '@/api/UserAPI'
import WorkingTimeAPI from '@/api/WorkingTimeAPI'
// Ajoute les autres APIs pour clocks, teams, etc.

/**
 * Création de la base de données LokiJS.
 */
const db = new Loki('timemanagerdb', {
  autosave: true,
  autosaveInterval: 5000,
  persistenceMethod: 'localStorage'
})

const usersCollection = db.getCollection('users') || db.addCollection('users', { unique: ['id'] })
const workingTimesCollection =
  db.getCollection('workingTimes') || db.addCollection('workingTimes', { unique: ['id'] })
const clocksCollection =
  db.getCollection('clocks') || db.addCollection('clocks', { unique: ['id'] })
const teamsCollection = db.getCollection('teams') || db.addCollection('teams', { unique: ['id'] })
const logsCollection = db.getCollection('logs') || db.addCollection('logs', { unique: ['id'] })

// Fonction de synchronisation des données non synchronisées avec le serveur
const syncLocalDataWithServer = async () => {
  // Synchronisation des utilisateurs
  await syncCollection(usersCollection, UserAPI.updateUser)

  // Synchronisation des temps de travail
  await syncCollection(workingTimesCollection, WorkingTimeAPI.updateWorkingTime)

  // Ajoute des appels pour synchroniser les autres collections (clocks, teams, etc.)
  // Par exemple :
  // await syncCollection(clocksCollection, ClockAPI.updateClock)

  db.saveDatabase((err) => {
    if (err) {
      console.error('Error saving database after sync:', err)
    } else {
      console.log('Database saved successfully after synchronization.')
    }
  })
}

// Fonction générique pour synchroniser une collection avec l'API
const syncCollection = async (collection, apiCall) => {
  const unsyncedData = collection.find({ synced: false })
  for (const data of unsyncedData) {
    try {
      await apiCall(data.id, data.data.user)
      data.synced = true
      collection.update(data)
      console.log(`Data for ${data.id} synced successfully.`)
    } catch (error) {
      console.error(`Error syncing data for ${data.id}:`, error)
    }
  }
}

export {
  db,
  usersCollection,
  workingTimesCollection,
  clocksCollection,
  teamsCollection,
  logsCollection,
  syncLocalDataWithServer // Export de la fonction de synchronisation
}
