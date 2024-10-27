import { HttpClient } from '@/api/config/HttpClient.js'

/**
 * LoadAllUsers
 * This method find all users. Inside a component, you can use the store and the store will call this method to store the data.
 * This data and endpoints will be accessed only by admin.
 * @returns {Promise} - Return a promise with the response data.
 */
export const loadAllUsers = () =>
  HttpClient.get('/users')
    .then((res) => res.data)
    .catch((error) => {
      console.error('Error fetching users:', error)
      throw error
    })

/**
 * getUserById
 * This method find a user by id.
 * @param id
 * @returns {Promise<axios.AxiosResponse<any>>}
 */
export const getUserById = (id) => HttpClient.get(`/users/${id}`).then((res) => res.data)

/**
 * createUser
 * This method create a new user.
 * @param data
 * @returns {Promise<axios.AxiosResponse<any>>}
 */
export const createUser = (data) => HttpClient.post('/users', data).then((res) => res.data)

/**
 * updateUser
 * This method update a user by id.
 */
export const updateUser = (id, data) => HttpClient.put(`/users/${id}`, data).then((res) => res.data)

/**
 * deleteUser
 * This method delete a user by id.
 * @param id
 * @returns {Promise<axios.AxiosResponse<any>>}
 */
export const deleteUser = (id) => HttpClient.delete(`/users/${id}`).then((res) => res.data)

export default {
  loadAllUsers,
  getUserById,
  createUser,
  updateUser,
  deleteUser
}
