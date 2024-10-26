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
  const isLoading = ref(false)
  const error = ref(null)
  const $toast = useToast()
  const options = {
    position: 'top-left',
    duration: 1000,
    dismissible: true
  }

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
    isLoading.value = false
  }

  return {
    workingTimes,
    workingTimesByDay,
    isLoading,
    error,
    loadWorkingTimes,
    loadWorkingTimesByDay,
    createWorkingTime,
    updateWorkingTime,
    deleteWorkingTime
  }
})
