import { HttpClient } from '@/api/config/HttpClient.js'

/**
 * getClocksByUserId
 * This method fetches clocks for a specific user by their ID.
 * @param {number} userId
 * @returns {Promise} - Returns a promise with the response data.
 */
export const getClocksByUserId = (userId) =>
  HttpClient.get(`/clocks/${userId}`).then((res) => res.data)

/**
 * createClock
 * This method creates a new clock for a specific user.
 * @param {Object} data - The clock data (time, status, userId).
 * @returns {Promise} - Returns a promise with the response data.
 */
export const createClock = (data) =>
  HttpClient.post(`/clocks/${data.userId}`, {
    clocks: {
      time: data.time,
      status: data.status,
      userId: data.userId
    }
  }).then((res) => res.data)

export default {
  getClocksByUserId,
  createClock
}
