<script setup>
import { ref } from 'vue'
import WorkingTimeManager from '@components/WorkingTimeManager/WorkingTimeManager.vue'
import WorkingTimeVisualization from '@components/WorkingTimeVisualization/WorkingTimeVisualization.vue'
import ClockManager from '@components/ClockManager/ClockManager.vue'
import Card from '@components/Card/Card.vue'
import clockIcon from '@assets/icons/icons8-clock-48.png'
import userIcon from '@assets/icons/icons8-user-48.png'
import workIcon from '@assets/icons/icons8-work-48.png'
import sliceIcon from '@assets/icons/icons8-slice-48.png'
import UserDisplay from '@components/user/UserDisplay/UserDisplay.vue'

const props = defineProps({
  userId: {
    type: Number,
    required: true
  }
})

// Used to store the working times
const workingTimes = ref([])

/**
 * Method used to update the working times
 * @param updatedTimes
 */
const updateWorkingTimes = (updatedTimes) => {
  workingTimes.value = updatedTimes
}

// Authentication state
const isAuthenticated = ref(false)

// Function to handle successful login
function handleLoginSuccess() {
  isAuthenticated.value = true
}

function getDate() {
  return new Date().toLocaleDateString('en-GB', {
    day: '2-digit',
    month: 'long',
    year: 'numeric'
  })
}
</script>

<template>
  <v-container>
    <v-row>
      <v-col cols="12" md="3">
        <Card :logo="userIcon" subtitle="User Information" title="User Info">
          <UserDisplay :userId="userId" />
        </Card>
      </v-col>

      <v-col cols="12" md="9">
        <Card :logo="sliceIcon" subtitle="Working time" title="Working Time Visualization">
          <WorkingTimeVisualization :userId="userId" :workingTimes="workingTimes" />
        </Card>
      </v-col>

      <v-col cols="12" md="3">
        <Card :logo="clockIcon" :subtitle="getDate()" subtitle="Clock" title="Clock Manager">
          <ClockManager :userId="userId" />
        </Card>
      </v-col>

      <v-col cols="12" md="9">
        <Card :logo="workIcon" subtitle="Manager" title="Working Time Manager">
          <WorkingTimeManager :userId="userId" @workingTimesUpdated="updateWorkingTimes" />
        </Card>
      </v-col>
    </v-row>
  </v-container>
</template>
<style scoped src="./AdminView.css"></style>