import { defineStore } from 'pinia'
import { ref } from 'vue'
import { createClock, getClocksByUserId } from '@/api/ClockAPI'
import { handleApiRequest } from '@config/lokiJS/syncHelper'
import { useToast } from 'vue-toast-notification'
import 'vue-toast-notification/dist/theme-sugar.css'

export const useClockStore = defineStore('clockStore', () => {
  const clocks = ref([])
  const isLoading = ref(false)
  const $toast = useToast()
  const options = {
    position: 'top-left',
    duration: 1000,
    dismissible: true
  }

  /**
   * Function to load clocks for a user.
   *
   * @param {number} userId - The ID of the user whose clocks are to be loaded.
   */
  const loadClocks = async (userId) => {
    isLoading.value = true
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
    const newClock = await handleApiRequest('create', data, 'createClock')
    $toast.success('Clock-in/out done!', options)
    clocks.value.push(newClock)
    isLoading.value = false
  }

  return {
    clocks,
    isLoading,
    loadClocks,
    createClock
  }
})
