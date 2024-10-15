<script setup>
import {ref} from 'vue';
import WorkingTimeManager from '@/components/WorkingTimeManager/WorkingTimeManager.vue';
import WorkingTimeVisualization from '../components/WorkingTimeVisualization/WorkingTimeVisualization.vue';
import ClockManager from '../components/ClockManager/ClockManager.vue';
import UserComponent from '../components/UserSearch/UserSearch.vue';
import CardComponent from '../components/Card/Card.vue';
import calendarIcon from '@assets/icons/icons8-calendar-10-48.png';
import clockIcon from '@assets/icons/icons8-clock-48.png';
import userIcon from '@assets/icons/icons8-user-48.png';
import imageIcon from '@assets/icons/icons8-image-48.png';
import workIcon from '@assets/icons/icons8-work-48.png';
import sliceIcon from '@assets/icons/icons8-slice-48.png';

// Used to store the working times
const workingTimes = ref([]);

/**
 * Method used to update the working times
 * @param updatedTimes
 */
const updateWorkingTimes = (updatedTimes) => {
  workingTimes.value = updatedTimes;
};

// Authentication state
const isAuthenticated = ref(false);

// Function to handle successful login
function handleLoginSuccess() {
  isAuthenticated.value = true;
}
function toImagePath(path){
  return require(path);
}
function getDate(){
  return new Date().toLocaleDateString('en-GB', {
        day: '2-digit',
        month: 'long',
        year: 'numeric',
      })
}
</script>

<template>
  <v-container>
    <v-row>
      <v-col cols="12" md="4">
        <CardComponent title="User Info" subtitle="Find user" :logo="userIcon">
          <UserComponent/>
        </CardComponent>
      </v-col>
      <v-col cols="12" md="8">
        <CardComponent title="Working Time Visualization" subtitle="Working time" :logo="sliceIcon">
          <WorkingTimeVisualization :userId="1" :workingTimes="workingTimes"/>
        </CardComponent>
      </v-col>
      <v-col cols="12" md="4">
        <CardComponent 
        title="Clock Manager" 
        :subtitle="getDate()"
        :logo="clockIcon">
          <ClockManager :userId="1"/>
        </CardComponent>
      </v-col>
      <v-col cols="12" md="8">
        <CardComponent title="Working Time Manager" subtitle="Manager" :logo="workIcon">
          <WorkingTimeManager :userId="1" @workingTimesUpdated="updateWorkingTimes"/>
        </CardComponent>
      </v-col>
    </v-row>
  </v-container>
</template>


<style src="./HomeView.css" scoped></style>
