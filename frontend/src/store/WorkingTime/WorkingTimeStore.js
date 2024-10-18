import { defineStore } from 'pinia'
import WorkingTimeAPI from '@/api/WorkingTimeAPI'

const { getWorkingTimesByUserId, createWorkingTime, updateWorkingTime, deleteWorkingTime } =
  WorkingTimeAPI

export const useWorkingTimeStore = defineStore('workingTimeStore', {
  state: () => ({
    workingTimes: [],
    isLoading: false,
    error: null
  }),

  actions: {
    async loadWorkingTimes(userId, start = null, end = null) {
      this.isLoading = true
      this.error = null
      this.workingTimes = await getWorkingTimesByUserId(userId, start, end)
      this.isLoading = false
    },

    async createWorkingTime(start, end, userId) {
      this.isLoading = true
      this.error = null
      await createWorkingTime(start, end, userId) //const newWorkingTime =
      //this.workingTimes.push(newWorkingTime)
      this.isLoading = false
    },

    async updateWorkingTime(id, data) {
      this.isLoading = true
      this.error = null
      const updatedWorkingTime = await updateWorkingTime(id, data)
      this.workingTimes = this.workingTimes.map((wt) => (wt.id === id ? updatedWorkingTime : wt))
      this.isLoading = false
    },

    async deleteWorkingTime(id) {
      this.isLoading = true
      this.error = null
      await deleteWorkingTime(id)
      this.workingTimes = this.workingTimes.filter((wt) => wt.id !== id)
      this.isLoading = false
    }
  }
})