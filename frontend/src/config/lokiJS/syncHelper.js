import { db, syncQueue } from '@config/lokiJS/loki'
import UserAPI from '@/api/UserAPI'
import { convertDatesToISO } from '@utils/utils'

const apiActions = {
  createUser: UserAPI.createUser,
  updateUser: UserAPI.updateUser,
  deleteUser: UserAPI.deleteUser
}

/**
 * Adds an API call and its data to the `syncQueue` table.
 *
 * @param {string} action - The action to perform ('create', 'update', 'delete').
 * @param {Object} data - The data to send to the API.
 * @param {string} apiActionName - The name of the API action to call.
 * @param {string|null} [id=null] - The ID of the entity to update (optional).
 */
const addToQueue = (action, data, apiActionName, id = null) => {
  if (!apiActionName) {
    console.warn(`Warning: Missing apiActionName for action: ${action}`)
  }
  const processedData = convertDatesToISO(data)
  const queueItem = {
    id: Date.now(),
    action,
    data: processedData,
    apiActionName,
    synced: false,
    entityId: id
  }
  syncQueue.insert(queueItem)
  db.saveDatabase()
}

/**
 * Handles an API call based on the connection status.
 * If online, makes the call directly; otherwise, adds the call to the queue.
 *
 * @param {string} action - The action to perform ('create', 'update', 'delete').
 * @param {Object} data - The data to send to the API.
 * @param {string} apiActionName - The name of the API action to call.
 * @param {string|null} [id=null] - The ID of the entity to update (optional).
 * @returns {Promise<Object>} - The data returned by the API or the local data if queued.
 */
const handleApiRequest = async (action, data, apiActionName, id = null) => {
  const apiCall = apiActions[apiActionName]

  if (!apiCall) {
    throw new Error(`API action ${apiActionName} not found`)
  }

  if (navigator.onLine) {
    try {
      return id ? await apiCall(id, data) : await apiCall(data)
    } catch (error) {
      console.error(`Error executing ${action} request online:`, error)
      addToQueue(action, data, apiActionName, id)
      return data
    }
  } else {
    addToQueue(action, data, apiActionName, id)
    return data
  }
}

/**
 * Processes the items in the `syncQueue` that have not been synced yet.
 * For each item, it attempts to call the corresponding API action.
 * If the API call is successful, the item is marked as synced.
 * If the API action is not found or an error occurs, it logs the error.
 */
const processQueue = async () => {
  const queueItems = syncQueue.find({ synced: false })

  for (const item of queueItems) {
    try {
      const apiCall = apiActions[item.apiActionName]
      if (apiCall) {
        const processedData = convertDatesToISO(item.data)
        await (item.entityId ? apiCall(item.entityId, processedData) : apiCall(processedData))
        item.synced = true
        syncQueue.update(item)
      } else {
        console.error(`No API function found for action: ${item.apiActionName}`)
      }
    } catch (error) {
      console.error(`Error processing queue item ${item.id}:`, error)
    }
  }
  db.saveDatabase()
}

window.addEventListener('online', processQueue)

export { addToQueue, handleApiRequest, processQueue }
