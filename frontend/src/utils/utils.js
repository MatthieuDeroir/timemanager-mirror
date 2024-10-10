/**
 * Format a date time string to a human-readable date
 * @param {string} dateTime - Date time string
 * @returns {string} - Formatted date string
 */
const formatDate = function (dateTime) {
  const date = new Date(dateTime)
  return date.toLocaleDateString() // Formate en chaîne de caractères lisible
}

/**
 * Format a date time string to a human-readable time
 * @param {string} dateTime - Date time string
 * @returns {string} - Formatted time string
 */
const formatTime = function (dateTime) {
  const date = new Date(dateTime)
  return date.toLocaleTimeString() // Formate l'heure
}

const Utils = {
  formatDate,
  formatTime
}

export default Utils
