<script setup>
import { ref } from 'vue'
import WorkingTimeManager from '@/components/WorkingTimeManager/WorkingTimeManager.vue'
import WorkingTimeVisualization from '../components/WorkingTimeVisualization/WorkingTimeVisualization.vue'
import ClockManager from '../components/ClockManager/ClockManager.vue'
import UserComponent from '../components/UserSearch/UserSearch.vue'
import CardComponent from '../components/Card/Card.vue'
// Used to store the working times
const workingTimes = ref([])

/**
 * Method used to update the working times
 * @param updatedTimes
 */
const updateWorkingTimes = (updatedTimes) => {
  workingTimes.value = updatedTimes
}
</script>

<template>
  <v-container>
    <v-row>
      <v-col cols="12" md="3">
        <CardComponent subtitle="Find user" title="User Info">
          <UserComponent />
        </CardComponent>
      </v-col>
      <v-col cols="12" md="9">
        <CardComponent subtitle="Working time" title="Working Time Visualization">
          <WorkingTimeVisualization :userId="1" :workingTimes="workingTimes" />
        </CardComponent>
      </v-col>
      <v-col cols="12" md="3">
        <CardComponent subtitle="Clock" title="Clock Manager">
          <ClockManager />
        </CardComponent>
      </v-col>
      <v-col cols="12" md="9">
        <CardComponent subtitle="Manager" title="Working Time Manager">
          <WorkingTimeManager :userId="1" @workingTimesUpdated="updateWorkingTimes" />
        </CardComponent>
      </v-col>
    </v-row>
  </v-container>
</template>

<style scoped src="./HomeView.css"></style>
