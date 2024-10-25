import { defineStore } from 'pinia'
import { ref } from 'vue'
import LogsAPI from '@/api/LogsAPI'

export const useLogsStore = defineStore('logsStore', () => {
  const logs = ref([])
  const isLoading = ref(false)

  /**
   * Load all logs by userId
   * This method find all logs by userId. Inside a component, you can use the store and the store will call this method to store the data.
   * Using pagination improves the performance of the application.
   * @param userId
   * @param page
   * @param pageSize
   * @returns {Promise<void>}
   */
  const loadAllLogsByUserId = async (userId, page, pageSize) => {
    isLoading.value = true
    logs.value = await LogsAPI.loadAllLogsByUserId(userId, page, pageSize)
    isLoading.value = false
  }

  return {
    logs,
    isLoading,
    loadAllLogsByUserId
  }
})
