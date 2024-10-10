// clockService.js

const API_BASE_URL = process.env.VUE_APP_API_BASE_URL;

/**
 * Fetch clocks for a specific user
 * @param {number} userId
 * @returns {Promise<ClockDTO[]>}
 */
export async function getClocksByUserId(userId) {
  const response = await fetch(`${API_BASE_URL}clocks/${userId}`);
  return response.json();
}

/**
 * Create a new clock for a user
 * @param {string} time
 * @param {boolean} status
 * @param {number} userId
 * @returns {Promise<ClockDTO>}
 */
export async function createClock(time, status, userId) {
  const response = await fetch(`${API_BASE_URL}clocks/${userId}`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      clocks: {
        time,
        status,
        userId
      }
    })
  });
  return response.json();
}

