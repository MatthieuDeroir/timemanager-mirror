<script setup>
import {onMounted, ref, watch} from 'vue';
import {getWorkingTimesByUserId} from '@services/workingtimeServices.js';
import WorkingTimeTable from './WorkingTable/WorkingTable.vue';

const props = defineProps({
  userId: {
    type: [String, Number],
    required: true
  },
  workingTimes: {
    type: Array,
    default: () => []
  }
});

const loading = ref(true);
const error = ref(null);
const totalHoursByDay = ref({});
const startDate = ref(null);
const endDate = ref(null);

const fetchWorkingTimes = async () => {
  try {
    loading.value = true;
    error.value = null;

    const workingTimes = props.workingTimes.length > 0
        ? props.workingTimes
        : await getWorkingTimesByUserId(props.userId, startDate.value, endDate.value);

    totalHoursByDay.value = calculateTotalHoursByDay(workingTimes);
  } catch (err) {
    error.value = err.message || 'Une erreur est survenue lors de la récupération des données.';
  } finally {
    loading.value = false;
  }
};

const calculateTotalHoursByDay = (workingTimes) => {
  const totalHours = {};
  workingTimes.forEach((time) => {
    const startDate = new Date(time.start);
    const endDate = new Date(time.end);
    const dateKey = startDate.toLocaleDateString();
    const hoursWorked = (endDate - startDate) / (1000 * 60 * 60);

    if (totalHours[dateKey]) {
      totalHours[dateKey] += hoursWorked;
    } else {
      totalHours[dateKey] = hoursWorked;
    }
  });
  return totalHours;
};

onMounted(() => fetchWorkingTimes());

watch(() => props.userId, () => {
  fetchWorkingTimes();
});

watch(() => props.workingTimes, (newWorkingTimes) => {
  totalHoursByDay.value = calculateTotalHoursByDay(newWorkingTimes);
}, {deep: true});
</script>

<template>
  <div>
    <h2>Visualisation des heures de travail</h2>
    <p v-if="loading">Chargement des données...</p>
    <p v-if="error">{{ error }}</p>
    <WorkingTimeTable v-if="!loading && !error" :totalHoursByDay="totalHoursByDay"/>
  </div>
</template>
