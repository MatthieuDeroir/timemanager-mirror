// workingTimeService.js

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL

/**
 * Fetch working times for a specific user, with optional date range filtering
 * @param {number} userId
 * @param {string} [start] - Optional start date for filtering
 * @param {string} [end] - Optional end date for filtering
 * @returns {Promise<WorkingTimeDTO[]>}
 */
export async function getWorkingTimesByUserId(userId, start = null, end = null) {
  const queryParams = new URLSearchParams()
  if (start) queryParams.append('start', start)
  if (end) queryParams.append('end', end)
  const response = await fetch(`${API_BASE_URL}workingtime/${userId}?${queryParams.toString()}`)
  return response.json()
}

/**
 * Fetch a specific working time by its ID for a user
 * @param {number} userId
 * @param {number} workingTimeId
 * @returns {Promise<WorkingTimeDTO>}
 */
export async function getWorkingTimeById(userId, workingTimeId) {
  const response = await fetch(`${API_BASE_URL}workingtime/${userId}/${workingTimeId}`)
  return response.json()
}

/**
 * Create a new working time for a user
 * @param {string} start
 * @param {string} end
 * @param {number} userId
 * @returns {Promise<WorkingTimeDTO>}
 */
export async function createWorkingTime(start, end, userId) {
  const response = await fetch(`${API_BASE_URL}workingtime/${userId}`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      workingtime: {
        start,
        end
      }
    })
  })
  return response.json()
}

/**
 * Update a working time by ID
 * @param {number} workingTimeId
 * @param {Object} workingTimeParams - Fields to update
 * @returns {Promise<WorkingTimeDTO>}
 */
export async function updateWorkingTime(workingTimeId, workingTimeParams) {
  const response = await fetch(`${API_BASE_URL}workingtime/${workingTimeId}`, {
    method: 'PUT',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      workingtime: workingTimeParams
    })
  })
  return response.json()
}

/**
 * Delete a working time by ID
 * @param {number} workingTimeId
 * @returns {Promise<void>}
 */
export async function deleteWorkingTime(workingTimeId) {
  await fetch(`${API_BASE_URL}workingtime/${workingTimeId}`, {
    method: 'DELETE'
  })
}

export default {
  getWorkingTimesByUserId,
  getWorkingTimeById,
  createWorkingTime,
  updateWorkingTime,
  deleteWorkingTime
}
