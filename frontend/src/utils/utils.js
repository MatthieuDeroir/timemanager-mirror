/**
 * Format a date time string to a human-readable date
 * @param {string} dateTime - Date time string
 * @returns {string} - Formatted date string
 */
const formatDate = function (dateTime) {
  const date = new Date(dateTime)
  return date.toLocaleDateString()
}

/**
 * Format a date time string to a human-readable time
 * @param {string} dateTime - Date time string
 * @returns {string} - Formatted time string
 */
const formatTime = function (dateTime) {
  const date = new Date(dateTime)
  return date.toLocaleTimeString()
}

/**
 * Format a date time string to a human-readable date and time
 * @example 2021-08-25T14:00:00.000Z -> "25/08/2021 14:00"
 * @returns {string} - Formatted date and time string
 * @param data
 */
export const convertDatesToISO = (data) => {
  if (typeof data !== 'object' || data === null) return data

  for (const key in data) {
    if (data[key] instanceof Date) {
      data[key] = data[key].toISOString()
    } else if (typeof data[key] === 'string' && !isNaN(Date.parse(data[key]))) {
      data[key] = new Date(data[key]).toISOString()
    } else if (typeof data[key] === 'object') {
      data[key] = convertDatesToISO(data[key])
    }
  }
  return data
}
