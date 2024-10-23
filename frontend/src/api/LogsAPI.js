import {HttpClient} from '@/api/config/HttpClient.js'

/**
 * LoadAllLogs
 * This method find all users. Inside a component, you can use the store and the store will call this method to store the data.
 * This data and endpoints will be accessed only by admin.
 * @returns {Promise} - Return a promise with the response data.
 */
export const LoadAllLogs = () =>
  HttpClient.get('/logs')
    .then((res) => res.data)
    .catch((error) => {
      console.error('Error fetching users:', error)
      throw error
    })

export default {
  LoadAllLogs,
  
}