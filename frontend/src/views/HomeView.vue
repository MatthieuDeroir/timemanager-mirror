<script setup>
import { ref } from 'vue';
import WorkingTimeManager from '@/components/WorkingTimeManager/WorkingTimeManager.vue';
import WorkingTimeVisualization from '../components/WorkingTimeVisualization/WorkingTimeVisualization.vue';
import Calendar from '../components/Calendar.vue'
import ClockManager from '../components/ClockManager/ClockManager.vue'
import UserComponent from '../components/User/UserComponent.vue';

// Réactif pour stocker les données des working times
const workingTimes = ref([]);

// Fonction appelée lorsque l'événement est émis
const updateWorkingTimes = (updatedTimes) => {
  workingTimes.value = updatedTimes;
};
</script>

<template>
  <main>
    <WorkingTimeVisualization :userId="1" :workingTimes="workingTimes" />
    <WorkingTimeManager :userId="1" @workingTimesUpdated="updateWorkingTimes" />
    <Calendar />
    <ClockManager />
    <UserComponent/>
  </main>
</template>
