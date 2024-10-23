import { defineStore } from 'pinia'
import { ref } from 'vue'
import { syncAllCollections, usersCollection } from '@/loki'
import UserAPI from '@/api/UserAPI'

export const useUserStore = defineStore('userStore', () => {
  const users = ref([])
  const isLoading = ref(false)
  const error = ref(null)

  const loadAllUsers = () => {
    isLoading.value = true
    error.value = null

    if (navigator.onLine) {
      UserAPI.getAllUsers()
        .then((serverUsers) => {
          users.value = serverUsers
          usersCollection.clear()
          usersCollection.insert(serverUsers)
        })
        .catch((err) => {
          console.error('Erreur lors de la récupération des utilisateurs depuis le serveur', err)
          error.value = 'Impossible de charger les utilisateurs depuis le serveur.'
          users.value = usersCollection.find()
        })
        .finally(() => {
          isLoading.value = false
        })
    } else {
      users.value = usersCollection.find()
      isLoading.value = false
    }
  }

  const createUser = (data) => {
    isLoading.value = true
    error.value = null

    const newUser = { ...data, id: Date.now(), synced: false, action: 'create' }
    usersCollection.insert(newUser)
    users.value.push(newUser)

    if (navigator.onLine) {
      syncAllCollections()
    }

    isLoading.value = false
  }

  const updateUser = (id, data) => {
    isLoading.value = true
    error.value = null

    console.log('=>(UserStore.js:79) data', data)

    const existing = usersCollection.findOne({ id })

    if (existing) {
      Object.assign(existing, data)

      existing.synced = false
      existing.action = 'update'

      usersCollection.update(existing)
      users.value = users.value.map((user) => (user.id === id ? existing : user))
    } else {
      console.error(`User with id ${id} not found`)
    }

    if (navigator.onLine) {
      console.log('=>(UserStore.js:65) update if navigator online')
      syncAllCollections()
    }

    isLoading.value = false
  }

  const deleteUser = (id) => {
    isLoading.value = true
    error.value = null

    const existing = usersCollection.findOne({ id })
    if (existing) {
      existing.synced = false
      existing.action = 'delete'
      usersCollection.update(existing)
    }

    users.value = users.value.filter((user) => user.id !== id)

    if (navigator.onLine) {
      syncAllCollections()
    }
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