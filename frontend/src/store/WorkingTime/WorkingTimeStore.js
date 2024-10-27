import { defineStore } from 'pinia'
import WorkingTimeAPI from '@/api/WorkingTimeAPI'
import { ref } from 'vue'
import { handleApiRequest } from '@config/lokiJS/syncHelper'
import { useToast } from 'vue-toast-notification'
import 'vue-toast-notification/dist/theme-sugar.css'

/**
 * Store for working times.
 * You can import this store in your components and use it to manage working times.
 * @example import { useWorkingTimeStore } from '@/store/WorkingTime/WorkingTimeStore'
 * @example const workingTimeStore = useWorkingTimeStore()
 * @example workingTimeStore.loadWorkingTimes(1)
 */
export const useWorkingTimeStore = defineStore('workingTimeStore', () => {
  const workingTimes = ref([])
  const workingTimesByDay = ref([])
  const startDate = ref(getMondayOfCurrentWeek())
  const endDate = ref(calculateEndDate(startDate.value))
  const isLoading = ref(false)
  const error = ref(null)
  const $toast = useToast()
  const options = {
    position: 'top-left',
    duration: 1000,
    dismissible: true
  }

  const formatStartDate = (date) => `${date} 00:00:00`
  const formatEndDate = (date) => `${date} 23:59:59`

  /**
   * Loads all working times for a user from the API.
   * Sets the `isLoading` state to true while loading and false after loading.
   */
  const loadWorkingTimes = async (userId, start = null, end = null) => {
    isLoading.value = true
    error.value = null
    workingTimes.value = await WorkingTimeAPI.getWorkingTimesByUserId(userId, start, end)
    isLoading.value = false
  }

  /**
   * Loads working times for a user by day from the API.
   * @param userId
   * @param start
   * @param end
   * @returns {Promise<void>}
   */
  const loadWorkingTimesByDay = async (userId, start, end) => {
    isLoading.value = true
    error.value = null
    workingTimesByDay.value = await WorkingTimeAPI.getWorkingTimesByUserId(userId, start, end)
    isLoading.value = false
  }

  /**
   * Creates a new working time for a user.
   * @param start
   * @param end
   * @param userId
   * @returns {Promise<Object>}
   */
  const createWorkingTime = async (start, end, userId) => {
    isLoading.value = true
    error.value = null
    const newWorkingTime = await handleApiRequest(
      'create',
      { start, end, userId },
      'createWorkingTime'
    )
    $toast.success('WorkingTime successfully created.', options)

    workingTimes.value.push(newWorkingTime)
    updateChartData()

    isLoading.value = false

    return newWorkingTime
  }

  /**
   * Updates a working time for a user.
   * @param id
   * @param data
   * @returns {Promise<void>}
   */
  const updateWorkingTime = async (id, data) => {
    isLoading.value = true
    error.value = null
    const updatedWorkingTime = await handleApiRequest('update', data, 'updateWorkingTime', id)
    $toast.success('WorkingTime successfully edited.', options)

    workingTimes.value = workingTimes.value.map((wt) => (wt.id === id ? updatedWorkingTime : wt))
    updateChartData()

    isLoading.value = false
  }

  /**
   * Deletes a working time for a user.
   * @param id
   * @returns {Promise<void>}
   */
  const deleteWorkingTime = async (id) => {
    isLoading.value = true
    error.value = null
    await handleApiRequest('delete', {}, 'deleteWorkingTime', id)


    $toast.success('WorkingTime successfully deleted.', options)
    workingTimes.value = workingTimes.value.filter((wt) => wt.id !== id)
    updateChartData()

    isLoading.value = false
  }

  /**
   * Returns the date of the Monday of the current week.
   * @returns {string}
   */
  function getMondayOfCurrentWeek() {
    const today = new Date()
    const day = today.getDay()
    const diff = today.getDate() - day + (day === 0 ? -6 : 1)
    return new Date(today.setDate(diff)).toISOString().split('T')[0]
  }

  function calculateEndDate(start) {
    const date = new Date(start)
    date.setDate(date.getDate() + 6)
    return date.toISOString().split('T')[0]
  }

  /**
   * Calculates the regular and overtime hours worked by day.
   * @returns {{regularHoursByDay: {}, overtimeByDay: {}, defaultDates: string[]}}
   */
  function calculateHoursByDay() {
    const regularHours = 7
    const regularHoursByDay = {}
    const overtimeByDay = {}

    const sortedDates = Array.from({ length: 7 }, (_, i) => {
      const date = new Date(startDate.value)
      date.setDate(date.getDate() + i)
      return date.toLocaleDateString('fr-FR')
    }).slice(0, 7)

    sortedDates.forEach(day => {
      regularHoursByDay[day] = 0
      overtimeByDay[day] = 0
    })

    workingTimes.value.forEach(({ start, end }) => {
      const day = new Date(start).toLocaleDateString('fr-FR')
      const workedHours = (new Date(end) - new Date(start)) / (1000 * 60 * 60)

      if (sortedDates.includes(day)) {
        regularHoursByDay[day] = Math.min(regularHours, workedHours)
        overtimeByDay[day] = Math.max(0, workedHours - regularHours)
      }
    })

    return { regularHoursByDay, overtimeByDay, defaultDates: sortedDates }
  }

  /**
   * Loads working times for a user for a specific date range.
   * @param userId
   * @returns {Promise<void>}
   */
  async function loadWorkingTimesForDateRange(userId) {
    isLoading.value = true

    endDate.value = calculateEndDate(startDate.value)
    await WorkingTimeAPI.getWorkingTimesByUserId(
        userId,
        formatStartDate(startDate.value),
        formatEndDate(endDate.value)
    )

    updateChartData()

    isLoading.value = false
  }

  /**
   * Updates the chart data with the latest working times.
   */
  function updateChartData() {
    const { regularHoursByDay, overtimeByDay, defaultDates } = calculateHoursByDay()
    workingTimesByDay.value = { regularHoursByDay, overtimeByDay, defaultDates }
  }

  return {
    workingTimes,
    workingTimesByDay,
    startDate,
    endDate,
    loadWorkingTimesForDateRange,
    isLoading,
    error,
    loadWorkingTimes,
    loadWorkingTimesByDay,
    createWorkingTime,
    updateWorkingTime,
    deleteWorkingTime
  }
})
