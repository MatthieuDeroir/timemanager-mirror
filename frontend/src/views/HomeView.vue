<script setup>
import { ref } from 'vue';
import WorkingTimeManager from '@/components/WorkingTimeManager/WorkingTimeManager.vue';
import WorkingTimeVisualization from '../components/WorkingTimeVisualization/WorkingTimeVisualization.vue';
import Calendar from '../components/Calendar.vue'
import ClockManager from '../components/ClockManager/ClockManager.vue'
import UserComponent from '../components/User/UserComponent.vue';
import HeaderComponent from '../components/Header/HeaderComponent.vue';
import LoginPage from '../components/LoginPage/LoginPage.vue';
// Réactif pour stocker les données des working times
const workingTimes = ref([]);

// Fonction appelée lorsque l'événement est émis
const updateWorkingTimes = (updatedTimes) => {
  workingTimes.value = updatedTimes;
};

// Authentication state
const isAuthenticated = ref(false); 

// Function to handle successful login
function handleLoginSuccess() {
  isAuthenticated.value = true;
}
</script>

<template>
  <div>
    <div v-if="!isAuthenticated">
      <LoginPage @login-success="handleLoginSuccess" />
    </div>

    <div v-else>
      <header>
        <HeaderComponent />
      </header>
      <main>
        <UserComponent/>
        <WorkingTimeVisualization :userId="1" :workingTimes="workingTimes" />
        <WorkingTimeManager :userId="1" @workingTimesUpdated="updateWorkingTimes" />
        <Calendar />
        <ClockManager />
      </main>
    </div>
  </div>
</template>
