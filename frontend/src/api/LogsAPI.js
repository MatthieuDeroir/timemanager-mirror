import { HttpClient } from '@/api/config/HttpClient.js'

/**
 * LoadAllLogs
 * This method find all users. Inside a component, you can use the store and the store will call this method to store the data.
 * This data and endpoints will be accessed only by admin.
 * @returns {Promise} - Return a promise with the response data.
 */
export const loadAllLogs = () =>
  HttpClient.get('/logs')
    .then((res) => res.data)
    .catch((error) => {
      console.error('Error fetching users:', error)
      throw error
    })

/**
 * LoadAllLogsByUserId
 * This method find all logs by userId. Inside a component, you can use the store and the store will call this method to store the data.
 * This data and endpoints will be accessed only by admin.
 * @param userId
 * @param page
 * @param pageSize
 * @returns {Promise<axios.AxiosResponse<any>>}
 */
export const loadAllLogsByUserId = (userId, page = 1, pageSize = 50) => {
  return HttpClient.get(`/logs/user/${userId}`, {
    params: {
      page,
      page_size: pageSize
    }
  })
    .then((res) => res.data)
    .catch((error) => {
      console.error('Error fetching logs:', error)
      throw error
    })
}

export default {
  loadAllLogs,
  loadAllLogsByUserId
}
