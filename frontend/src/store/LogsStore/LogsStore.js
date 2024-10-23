import { defineStore } from 'pinia';
import LogsAPI from '@/api/LogsAPI';

const { LoadAllLogs } = LogsAPI;

export const useLogsStore = defineStore('logsStore', {
  state: () => ({
    logs: [],
    isLoading: false,
    error: null,
  }),

  actions: {
    async loadAllLogs() {
      this.isLoading = true;
      this.error = null;

      try {
        this.logs = await LoadAllLogs();
      } catch (err) {
        this.error = 'Failed to load logs';
      } finally {
        this.isLoading = false;
      }
    },
  },
});
