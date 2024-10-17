import { defineStore } from 'pinia'
import { createClock, getClocksByUserId } from '@/api/ClockAPI'

export const useClockStore = defineStore('clockStore', {
  state: () => ({
    clocks: [],
    isLoading: false,
    error: null
  }),

  actions: {
    async loadClocks(userId) {
      this.isLoading = true
      this.error = null
      this.clocks = await getClocksByUserId(userId)
      this.isLoading = false
    },

    async createClock(data) {
      this.isLoading = true
      this.error = null
      const newClock = await createClock(data)
      this.clocks.push(newClock)
      this.isLoading = false
    }
  }
})