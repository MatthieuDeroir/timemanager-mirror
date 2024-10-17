import { defineStore } from 'pinia'
import UserAPI from '@/api/UserAPI'

const { loadAllUsers, deleteUser, createUser, updateUser } = UserAPI
export const useUserStore = defineStore('userStore', {
  state: () => ({
    users: [],
    isLoading: false,
    error: null
  }),

  actions: {
    async loadAllUsers() {
      this.isLoading = true
      this.error = null
      this.users = await loadAllUsers()
      this.isLoading = false
    },

    async createUser(data) {
      this.isLoading = true
      this.error = null
      const newUser = await UserAPI.createUser(data)
      this.users.push(newUser)
      this.isLoading = false
    },

    async updateUser(id, data) {
      this.isLoading = true
      this.error = null
      const updatedUser = await updateUser(id, data)
      this.users = this.users.map((user) => (user.id === id ? updatedUser : user))
      this.isLoading = false
    },

    async deleteUser(id) {
      this.isLoading = true
      this.error = null
      await deleteUser(id)
      this.users = this.users.filter((user) => user.id !== id)
      this.isLoading = false
    }
  }
})