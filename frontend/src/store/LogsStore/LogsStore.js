import { defineStore } from 'pinia'
import LogsAPI from '@/api/LogsAPI'
import { useToast } from 'vue-toast-notification'
import 'vue-toast-notification/dist/theme-sugar.css'

const { LoadAllLogs } = LogsAPI

export const useLogsStore = defineStore('logsStore', {
  state: () => ({
    logs: [],
    isLoading: false
  }),

  actions: {
    async loadAllLogs() {
      this.isLoading = true

      this.logs = await LoadAllLogs()

      this.isLoading = false
    }
  }
})
