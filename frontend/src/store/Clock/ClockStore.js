import { defineStore } from 'pinia'
import { ref } from 'vue'
import { createClock, getClocksByUserId } from '@/api/ClockAPI'
import { handleApiRequest } from '@config/lokiJS/syncHelper'

export const useClockStore = defineStore('clockStore', () => {
  const clocks = ref([])
  const isLoading = ref(false)
  const error = ref(null)

  /**
   * Function to load clocks for a user.
   *
   * @param {number} userId - The ID of the user whose clocks are to be loaded.
   */
  const loadClocks = async (userId) => {
    isLoading.value = true
    error.value = null
    clocks.value = await getClocksByUserId(userId)
    isLoading.value = false
  }
  /**
   * Function to create a new clock entry.
   *
   * @param {Object} data - The data for the new clock entry.
   */
  const createClock = async (data) => {
    isLoading.value = true
    error.value = null
    const newClock = await handleApiRequest('create', data, 'createClock')
    clocks.value.push(newClock)
    isLoading.value = false
  }

  return {
    clocks,
    isLoading,
    error,
    loadClocks,
    createClock
  }
})
