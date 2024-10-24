<template>
  
  <div v-if="loading"><Loader></Loader></div>
  <div v-else class="working-times custom">
    <button class="btn-primary add-button" @click="addNewWorkingTime">Add new working time</button>
    
    <div v-if="error" class="error">{{ error }}</div>
    <!-- Hours worked table-->
    <v-table class="table custom" fixed-header height="400px" density='compact' v-if="!loading">
      <thead class="custom">
        <tr class="custom">
          <th style="width: 30%;" class="custom">Start Time</th>
          <th style="width: 30%;" class="custom">End Time</th>
          <th style="width: 18%;" class="custom">Total</th>
          <th style="width: 22%;" class="custom">Actions</th>
        </tr>
      </thead>
      <tbody class="custom">
        <tr v-for="time in workingTimeStore.workingTimes" :key="time.id || time.tempId" class="custom">
          <td class="custom">
            <input v-if="time.isEditing" v-model="time.start" type="datetime-local" class="custom"/>
            <span v-else>{{ new Date(time.start).toLocaleString() }}</span>
          </td>
          <td class="custom">
            <input v-if="time.isEditing" v-model="time.end" type="datetime-local" />
            <span v-else>{{ new Date(time.end).toLocaleString() }}</span>
          </td>
          <td>{{ calculateHoursWorked(time.start, time.end) }} hours</td>
          <td class="action-button-container custom">
            <button class="btn-primary wt-btn" v-if="time.isEditing" @click="saveWorkingTime(time)">Save</button>
            <button class="btn-primary wt-btn" v-else @click="editWorkingTime(time)">Edit</button>
            <button class="btn-danger wt-btn" @click="deleteWorkingTime(time.id || time.tempId)">Delete</button>
          </td>
        </tr>
      </tbody>
    </v-table>
  </div>
</template>

<script setup>
import { ref,computed } from 'vue'
import Loader from '@components/Loader/LoaderComponent.vue'
import { useWorkingTimeStore } from '@store/WorkingTime/WorkingTimeStore.js'

// Récupérer les props
const props = defineProps({
  userId: {
    type: [String, Number],
    required: true
  }
})

const workingTimeStore = useWorkingTimeStore()
const loading = computed(() => workingTimeStore.isLoading)
const error = computed(() => workingTimeStore.error)
const nextTempId = ref(0) // Pour identifier temporairement les nouvelles lignes



// // Fonction pour récupérer les heures de travail d'un utilisateur
// const getWorkingTimes = async () => {
//   try {
//     workingTimes.value = await workingTimes.getWorkingTimesByUserId(props.userId)
    
//   } catch (err) {
//     error.value = err.message || 'An error occurred'
//   }
// }
//workingTimes.value.sort((a, b) => new Date(b.start) - new Date(a.start))

// Fonction pour calculer les heures travaillées entre deux dates
const calculateHoursWorked = (start, end) => {
  const startDate = new Date(start)
  const endDate = new Date(end)
  return ((endDate - startDate) / (1000 * 60 * 60)).toFixed(2)
}

// Ajouter une nouvelle entrée de temps de travail
const addNewWorkingTime = () => {
  if (workingTimeStore.workingTimes.some((t) => t.isEditing)) {
    return
  }
  workingTimeStore.workingTimes.unshift({
    tempId: nextTempId.value++, // Temp ID pour la nouvelle ligne
    start: '',
    end: '',
    isEditing: true
  })
}

// Editer une entrée existante
const editWorkingTime = (time) => {
  time.start = formatDateForInput(time.start)
  time.end = formatDateForInput(time.end)
  time.isEditing = true
}

// Sauvegarder une entrée de temps de travail
const saveWorkingTime = async (time) => {
  try {
    if (time.id) {
      // Si l'entrée existe déjà, on la met à jour
      await workingTimeStore.updateWorkingTime(time.id, { start: time.start, end: time.end })
    } else {
      // Si c'est une nouvelle entrée
      const createdTime = await workingTimeStore.createWorkingTime(time.start, time.end, props.userId)
      time.id = createdTime.id 
    }
    time.isEditing = false
    workingTimeStore.error = null
  } catch (err) {
    workingTimeStore.workingTimes = workingTimeStore.workingTimes.filter((t) => t.tempId !== time.tempId)
    workingTimeStore.error = err.message || 'Failed to save working time'
  } finally{
    time.isEditing = false
  }
}

// Supprimer une entrée de temps de travail
const deleteWorkingTime = async (idOrTempId) => {
  console.log(idOrTempId)
  const time = workingTimeStore.workingTimes.find((t) => t.id === idOrTempId || t.tempId === idOrTempId)
  if (time.id) {
    await workingTimeStore.deleteWorkingTime(time.id) // Si l'entrée existe dans la base, on la supprime
  }
}


// Formater la date pour un input `datetime-local`
const formatDateForInput = (dateString) => {
  const date = new Date(dateString)
  return date.toISOString().slice(0, 16) // Format "YYYY-MM-DDTHH:MM"
}


</script>

<style src="./WorkingTimeManager.css"></style>