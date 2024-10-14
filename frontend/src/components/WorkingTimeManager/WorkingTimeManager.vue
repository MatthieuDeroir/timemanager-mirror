<template>
  <div class="working-times">
    <h2>Management of the working times for User: {{ userId }}</h2>

    <div v-if="loading">Loading...</div>
    <div v-if="error" class="error">{{ error }}</div>

    <!-- Bouton pour ajouter une nouvelle ligne -->
    <button @click="addNewWorkingTime">Add new working time</button>

    <!-- Hours worked table-->
    <table v-if="!loading && !error">
      <thead>
      <tr>
        <th>Start Time</th>
        <th>End Time</th>
        <th>Total Hours Worked</th>
        <th>Actions</th>
      </tr>
      </thead>
      <tbody>
      <tr v-for="time in workingTimes" :key="time.id || time.tempId">
        <td>
          <input
              v-if="time.isEditing"
              type="datetime-local"
              v-model="time.start"
          />
          <span v-else>{{ new Date(time.start).toLocaleString() }}</span>
        </td>
        <td>
          <input
              v-if="time.isEditing"
              type="datetime-local"
              v-model="time.end"
          />
          <span v-else>{{ new Date(time.end).toLocaleString() }}</span>
        </td>
        <td>{{ calculateHoursWorked(time.start, time.end) }} hours</td>
        <td>
          <button v-if="time.isEditing" @click="saveWorkingTime(time)">Save</button>
          <button v-else @click="editWorkingTime(time)">Edit</button>
          <button @click="deleteWorkingTime(time.id || time.tempId)">Delete</button>
        </td>
      </tr>
      </tbody>
    </table>
  </div>
</template>

<script setup>
import {onMounted, ref} from 'vue';
import {
  createWorkingTime as createTime,
  deleteWorkingTime as deleteTime,
  getWorkingTimesByUserId,
  updateWorkingTime as updateTime
} from '../../services/workingtimeServices';

// Récupérer les props
const props = defineProps({
  userId: {
    type: [String, Number],
    required: true
  }
});

// Variables réactives pour l'état de chargement, les erreurs, et les heures de travail
const workingTimes = ref([]);
const loading = ref(true);
const error = ref(null);
const nextTempId = ref(0); // Pour identifier temporairement les nouvelles lignes

// Fonction pour récupérer les heures de travail d'un utilisateur
const getWorkingTimes = async () => {
  try {
    loading.value = true;
    error.value = null;
    workingTimes.value = await getWorkingTimesByUserId(props.userId);
  } catch (err) {
    error.value = err.message || 'An error occurred';
  } finally {
    loading.value = false;
  }
};

// Fonction pour calculer les heures travaillées entre deux dates
const calculateHoursWorked = (start, end) => {
  const startDate = new Date(start);
  const endDate = new Date(end);
  return ((endDate - startDate) / (1000 * 60 * 60)).toFixed(2);
};

// Ajouter une nouvelle entrée de temps de travail
const addNewWorkingTime = () => {
  workingTimes.value.push({
    tempId: nextTempId.value++, // Temp ID pour la nouvelle ligne
    start: '',
    end: '',
    isEditing: true
  });
};

// Editer une entrée existante
const editWorkingTime = (time) => {
  time.start = formatDateForInput(time.start);
  time.end = formatDateForInput(time.end);
  time.isEditing = true;
};

// Sauvegarder une entrée de temps de travail
const saveWorkingTime = async (time) => {
  if (!isSameDay(time.start, time.end)) {
    error.value = 'Start and End times must be on the same day.';
    return;
  }

  try {
    if (time.id) {
      // Si l'entrée existe déjà, on la met à jour
      await updateTime(time.id, {start: time.start, end: time.end});
    } else {
      // Si c'est une nouvelle entrée
      const newTime = await createTime(time.start, time.end, props.userId);
      time.id = newTime.id; // Assigner l'ID réel une fois créé
    }
    time.isEditing = false;
    error.value = null;
    getWorkingTimes(); // Rafraîchir la liste
  } catch (err) {
    error.value = err.message || 'Failed to save working time';
  }
};

// Supprimer une entrée de temps de travail
const deleteWorkingTime = async (idOrTempId) => {
  const time = workingTimes.value.find((t) => t.id === idOrTempId || t.tempId === idOrTempId);
  if (time.id) {
    await deleteTime(time.id); // Si l'entrée existe dans la base, on la supprime
  }
  // Supprimer localement
  workingTimes.value = workingTimes.value.filter(
      (t) => t.id !== idOrTempId && t.tempId !== idOrTempId
  );
};

// Vérifier si les dates de début et de fin sont sur le même jour
const isSameDay = (start, end) => {
  const startDate = new Date(start);
  const endDate = new Date(end);
  return (
      startDate.getFullYear() === endDate.getFullYear() &&
      startDate.getMonth() === endDate.getMonth() &&
      startDate.getDate() === endDate.getDate()
  );
};

// Formater la date pour un input `datetime-local`
const formatDateForInput = (dateString) => {
  const date = new Date(dateString);
  return date.toISOString().slice(0, 16); // Format "YYYY-MM-DDTHH:MM"
};

// Charger les données lors du montage du composant
onMounted(() => {
  getWorkingTimes();
});
</script>

<style src="./WorkingTimeManager.css"></style>