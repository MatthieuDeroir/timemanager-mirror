import { defineStore } from 'pinia'
import { ref } from 'vue'
import UserAPI from '@/api/UserAPI'
import { usersCollection } from '@config/loki'
import { handleSyncOperation } from '@utils/syncHelper'

export const useUserStore = defineStore('userStore', () => {
  const users = ref(usersCollection.find())
  const isLoading = ref(false)
  const error = ref(null)

  const loadAllUsers = async () => {
    isLoading.value = true
    error.value = null
    if (navigator.onLine) {
      try {
        const res = await UserAPI.loadAllUsers()
        users.value = res
        usersCollection.clear()
        usersCollection.insert(res)
        db.saveDatabase()
      } catch (err) {
        error.value = 'Error loading users from server.'
      }
    } else {
      users.value = usersCollection.find()
    }
    isLoading.value = false
  }

  const createUser = async (data) => {
    isLoading.value = true
    error.value = null
    await handleSyncOperation('create', data, usersCollection, () => UserAPI.createUser(data))
    users.value = usersCollection.find()
    isLoading.value = false
  }

  const updateUser = async (id, data) => {
    isLoading.value = true
    error.value = null
    await handleSyncOperation('update', { id, data }, usersCollection, () =>
      UserAPI.updateUser(id, data)
    )
    users.value = usersCollection.find()
    isLoading.value = false
  }

  const deleteUser = async (id) => {
    isLoading.value = true
    error.value = null
    await handleSyncOperation('delete', { id }, usersCollection, () => UserAPI.deleteUser(id))
    users.value = usersCollection.find()
    isLoading.value = false
  }

  return {
    users,
    isLoading,
    error,
    loadAllUsers,
    createUser,
    updateUser,
    deleteUser
  }
})