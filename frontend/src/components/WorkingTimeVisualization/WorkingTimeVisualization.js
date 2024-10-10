import { getWorkingTimesByUserId } from '../../services/workingtimeServices'
import Utils from '../../utils/utils'
/**
 * Get all working times for a user within a date range, the date range is optional.
 * If no date range is provided, all working times for the user are returned.
 * @returns {Promise<void>}
 * @throws {Error} if an error occurred
 */
export const getWorkingTimes = async function () {
  try {
    this.loading = true
    this.error = null
    this.workingTimes = await getWorkingTimesByUserId(this.userId, this.startDate, this.endDate)

    // Calculate the total hours worked per day
    this.totalHoursByDay = this.calculateTotalHoursByDay()
  } catch (err) {
    this.error = err.message || 'An error occurred'
  } finally {
    this.loading = false
  }
}

/**
 * Calculate the total hours worked per day from the working times
 * @returns {Object} - Object with date keys and total hours worked as values
 */
export const calculateTotalHoursByDay = function () {
  const totalHoursByDay = {}

  // Parcourir les workingTimes et regrouper les heures par jour
  this.workingTimes.forEach((time) => {
    const startDate = new Date(time.start)
    const endDate = new Date(time.end)

    const dateKey = startDate.toLocaleDateString()

    const hoursWorked = (endDate - startDate) / (1000 * 60 * 60)

    if (totalHoursByDay[dateKey]) {
      totalHoursByDay[dateKey] += hoursWorked
    } else {
      totalHoursByDay[dateKey] = hoursWorked
    }
  })

  return totalHoursByDay
}

export default {
  props: {
    userId: {
      type: [String, Number],
      required: true
    }
  },
  data() {
    return {
      workingTimes: [],
      loading: true,
      error: null,
      startDate: null,
      endDate: null,
      totalHoursByDay: {}
    }
  },
  methods: {
    getWorkingTimes,
    calculateTotalHoursByDay
  },
  mounted() {
    this.getWorkingTimes()
  }
}
