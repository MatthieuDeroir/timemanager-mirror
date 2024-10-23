import { defineStore } from 'pinia'
import { ref } from 'vue'
import { workingTimesCollection } from '@/loki'
import WorkingTimeAPI from '@/api/WorkingTimeAPI'

export const useWorkingTimeStore = defineStore('workingTimeStore', () => {
  const workingTimes = ref([])
  const isLoading = ref(false)
  const error = ref(null)

  const loadWorkingTimes = (userId) => {
    isLoading.value = true
    error.value = null

    if (navigator.onLine) {
      WorkingTimeAPI.getWorkingTimesByUserId(userId)
        .then((serverWorkingTimes) => {
          workingTimes.value = serverWorkingTimes

          workingTimesCollection.clear()
          workingTimesCollection.insert(serverWorkingTimes)
        })
        .catch((err) => {
          console.error('Erreur lors de la récupération des données depuis le serveur', err)
          error.value = 'Impossible de charger les données depuis le serveur.'
          workingTimes.value = workingTimesCollection.find()
        })
        .finally(() => {
          isLoading.value = false
        })
    } else {
      // Si offline, charger depuis LokiJS
      workingTimes.value = workingTimesCollection.find()
      isLoading.value = false
    }
  }

  const createWorkingTimeAction = (start, end, userId) => {
    isLoading.value = true
    error.value = null

    const newWorkingTime = { start, end, userId, id: Date.now(), synced: false, action: 'create' }
    workingTimesCollection.insert(newWorkingTime)
    workingTimes.value.push(newWorkingTime)

    isLoading.value = false
  }

  const updateWorkingTimeAction = (id, data) => {
    isLoading.value = true
    error.value = null

    const existing = workingTimesCollection.findOne({ id })
    Object.assign(existing, data, { synced: false, action: 'update' })
    workingTimesCollection.update(existing)
    workingTimes.value = workingTimes.value.map((wt) => (wt.id === id ? existing : wt))

    isLoading.value = false
  }

  const deleteWorkingTimeAction = (id) => {
    isLoading.value = true
    error.value = null

    const existing = workingTimesCollection.findOne({ id })
    if (existing) {
      existing.synced = false
      existing.action = 'delete'
      workingTimesCollection.update(existing)
    }

    workingTimes.value = workingTimes.value.filter((wt) => wt.id !== id)

    isLoading.value = false
  }

  return {
    workingTimes,
    isLoading,
    error,
    loadWorkingTimes,
    createWorkingTimeAction,
    updateWorkingTimeAction,
    deleteWorkingTimeAction
  }
})