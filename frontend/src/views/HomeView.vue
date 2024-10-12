<script setup>
import { ref } from 'vue';
import WorkingTimeManager from '@/components/WorkingTimeManager/WorkingTimeManager.vue';
import WorkingTimeVisualization from '../components/WorkingTimeVisualization/WorkingTimeVisualization.vue';
import Calendar from '../components/Calendar.vue'
import ClockManager from '../components/ClockManager/ClockManager.vue'
import UserComponent from '../components/User/UserComponent.vue';
import HeaderComponent from '../components/Header/HeaderComponent.vue';
import LoginPage from '../components/LoginPage/LoginPage.vue';
import CardComponent from '../components/CardComponent/CardComponent';
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
    <!-- <div v-if="!isAuthenticated">
      <LoginPage @login-success="handleLoginSuccess" />
    </div>

    <div v-else> -->
    <div>
      <header>
        <HeaderComponent />
      </header>
      <main>
        <div class="main-grid">
          <div class="UserComponent-grid">
            <CardComponent title="User Comp">
              <UserComponent/>
            </CardComponent>
          </div>
          <div class="WorkingTimeManager-grid">
            <WorkingTimeManager :userId="1" @workingTimesUpdated="updateWorkingTimes" />
          </div>
          <div class="Calendar-grid">
            <Calendar />
          </div>
          <div class="ClockManager-grid">
            <ClockManager />
          </div>
          <div class="WorkingTimeVisualization-grid">
            <WorkingTimeVisualization :userId="1" :workingTimes="workingTimes" />
          </div>
        </div>
      </main>
    </div>
  </div>
</template>

<style src="./HomeView.css" scoped></style>