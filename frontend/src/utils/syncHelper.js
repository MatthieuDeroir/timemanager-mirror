import {db} from '@config/loki'

/**
 * Handle different data operations (create, update, delete) with local and API sync.
 * The method manages offline-first logic by saving in LokiJS first and syncing with the API when online.
 *
 * @param {string} action - The action to perform ('create', 'update', 'delete').
 * @param {Object} data - The data to process.
 * @param {Object} collection - The LokiJS collection to modify.
 * @param {Function} apiCall - The API function for syncing with the server (if online).
 * @returns {Promise<void>}
 */
export const handleSyncOperation = async (action, data, collection, apiCall) => {
  // console.log('=>(syncHelper.js:31) handleSyncOperation inside ')
  // console.log('=>(syncHelper.js:23) apiCall', apiCall)
  // console.log('=>(syncHelper.js:23) collection', collection)
  // console.log('=>(syncHelper.js:23) data', data)
  // console.log('=>(syncHelper.js:23) action', action)
  // Step 1: Save data in LokiJS (localStorage)
  const newData = saveDataLocally(action, data, collection)
  // console.log('=>(syncHelper.js:21) newData', newData)

  if (navigator.onLine) {
    console.log('=>(syncHelper.js:34) navigator.onLine', navigator.onLine)
    await syncWithAPI(action, newData, collection, apiCall)
  }
}

/**
 * Save the data locally in LokiJS based on the action type.
 *
 * @param {string} action - The type of action ('create', 'update', 'delete').
 * @param {Object} data - The data to be saved.
 * @param {Object} collection - The LokiJS collection to update.
 * @returns {Object} - The saved data object (with updated fields like 'synced' and 'action').
 */
const saveDataLocally = (action, data, collection) => {
  let existingData = collection.findOne({ id: data.id })
  console.log('=>(syncHelper.js:38) existingData at the begining of savelocally', existingData)

  switch (action) {
    case 'create':
      if (!existingData) {
        const newData = { ...data, id: Date.now(), synced: false, action: 'create' }
        collection.insert(newData)
        db.saveDatabase()
        return newData
      }
      break

    case 'update':
      if (existingData) {
        Object.assign(existingData, data, { synced: false, action: 'update' })
        collection.update(existingData)

        db.saveDatabase((err) => {
          if (err) {
            console.error('Error saving database:', err)
          } else {
            console.log('Database saved successfully.')
          }
        })
        return existingData
      }
      break

    case 'delete':
      if (existingData) {
        existingData.synced = false
        existingData.action = 'delete'
        collection.update(existingData)
        db.saveDatabase()
        return existingData
      }
      break

    default:
      console.error(`Unknown action: ${action}`)
  }
}

/**
 * Sync the data with the API if online.
 *
 * @param {string} action - The type of action ('create', 'update', 'delete').
 * @param {Object} data - The data to sync with the API.
 * @param {Object} collection - The LokiJS collection to update after syncing.
 * @param {Function} apiCall - The API function to call for syncing the data.
 */
const syncWithAPI = async (action, data, collection, apiCall) => {
  console.log('=>(syncHelper.js:109) apiCall', apiCall)
  console.log('=>(syncHelper.js:109) collection', collection)
  console.log('=>(syncHelper.js:109) data', data)
  console.log('=>(syncHelper.js:109) action', action)
  try {
    if (action === 'delete') {
      await apiCall(data.id)
      collection.remove(data)
    } else {
      console.log('=>(syncHelper.js:99) DANS LE ELSE DE SYNCWITHAPI')
      console.log('=>(syncHelper.js:108) data', data)

      await apiCall(data)
      data.synced = true
      collection.update(data)
    }
  } catch (error) {
    console.error(`Error syncing ${action} operation`, error)
  }
}
