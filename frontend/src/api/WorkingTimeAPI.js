import { HttpClient } from '@/api/config/HttpClient.js'

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL

/**
 * Fetch working times for a specific user, with optional date range filtering
 * @param {number} userId
 * @param {string} [start] - Optional start date for filtering
 * @param {string} [end] - Optional end date for filtering
 * @returns {Promise<WorkingTimeDTO[]>}
 */
export const getWorkingTimesByUserId = (userId, start = null, end = null) => {
  const queryParams = new URLSearchParams()
  if (start) queryParams.append('start', start)
  if (end) queryParams.append('end', end)

  return HttpClient.get(`${API_BASE_URL}workingtime/${userId}?${queryParams.toString()}`)
    .then((res) => res.data)
    .catch((error) => {
      console.error('Error fetching working times:', error)
      throw error
    })
}

/**
 * Fetch a specific working time by its ID for a user
 * @param {number} userId
 * @param {number} workingTimeId
 * @returns {Promise<WorkingTimeDTO>}
 */
export const getWorkingTimeById = (userId, workingTimeId) =>
  HttpClient.get(`${API_BASE_URL}workingtime/${userId}/${workingTimeId}`)
    .then((res) => res.data)
    .catch((error) => {
      console.error('Error fetching working time by ID:', error)
      throw error
    })

/**
 * Create a new working time for a user
 * @param {string} start
 * @param {string} end
 * @param {number} userId
 * @returns {Promise<WorkingTimeDTO>}
 */
export const createWorkingTime = (start, end, userId) =>
  HttpClient.post(`${API_BASE_URL}workingtime/${userId}`, {
    workingtime: { start, end }
  })
    .then((res) => res.data)
    .catch((error) => {
      console.error('Error creating working time:', error)
      throw error
    })

/**
 * Update a working time by ID
 * @param {number} workingTimeId
 * @param {Object} workingTimeParams - Fields to update
 * @returns {Promise<WorkingTimeDTO>}
 */
export const updateWorkingTime = (workingTimeId, workingTimeParams) =>
  HttpClient.put(`${API_BASE_URL}workingtime/${workingTimeId}`, {
    workingtime: workingTimeParams
  })
    .then((res) => res.data)
    .catch((error) => {
      console.error('Error updating working time:', error)
      throw error
    })

/**
 * Delete a working time by ID
 * @param {number} workingTimeId
 * @returns {Promise<void>}
 */
export const deleteWorkingTime = (workingTimeId) =>
  HttpClient.delete(`${API_BASE_URL}workingtime/${workingTimeId}`)
    .then((res) => res.data)
    .catch((error) => {
      console.error('Error deleting working time:', error)
      throw error
    })

/**
 * Export default let us the possibility to import this entire file
 * as a module in another file.
 */
export default {
  getWorkingTimesByUserId,
  getWorkingTimeById,
  createWorkingTime,
  updateWorkingTime,
  deleteWorkingTime
}