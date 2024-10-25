<script setup>
import { ref } from 'vue'
import clockIcon from '@assets/icons/icons8-clock-48.png'
import sliceIcon from '@assets/icons/icons8-slice-48.png'
import userIcon from '@assets/icons/icons8-user-48.png'
import workIcon from '@assets/icons/icons8-work-48.png'
import teamIcon from '@assets/icons/icons8-team-48.png'

import Card from '@components/Card/Card.vue'

import WorkingTimeManager from '@components/WorkingTimeManager/WorkingTimeManager.vue'
import WorkingTimeVisualization from '@components/WorkingTimeVisualization/WorkingTimeVisualization.vue'
import ClockManager from '@components/ClockManager/ClockManager.vue'
import UserDisplay from '@components/user/UserDisplay/UserDisplay.vue'
import Team from '@components/Team/Team.vue'
import DailyChart from '@components/Chart/DailyChart.vue'

const props = defineProps({
  userId: {
    type: Number,
    required: true
  }
})

const userTitle = ref('User Info')
const userSubtitle = ref('User Information')
const userGender = ref('User Information')

const handleSelectedUser = (user) => {
  userTitle.value = `${user.firstname} ${user.lastname}`
  userSubtitle.value = user.email
  userGender.value = `(${user.gender})`
}

// Used to store the working times
const workingTimes = ref([])

/**
 * Method used to update the working times
 * @param updatedTimes
 */
const updateWorkingTimes = (updatedTimes) => {
  workingTimes.value = updatedTimes
}

// // Authentication state
// const isAuthenticated = ref(false)

// // Function to handle successful login
// function handleLoginSuccess() {
//   isAuthenticated.value = true
// }

const getDate = () => {
  return new Date().toLocaleDateString('en-GB', {
    day: '2-digit',
    month: 'long',
    year: 'numeric'
  })
}
</script>

<template>
  <v-container class="padding-top-view">
    <v-row>
      <v-col cols="12" md="6">
        <Card
          :logo="userIcon"
          :otherInfo="userGender"
          :subtitle="userSubtitle"
          :title="userTitle"
          color="blue"
        >
          <UserDisplay :userId="userId" @selecteduser="handleSelectedUser" />
        </Card>
      </v-col>
      <v-col cols="12" md="6" style="min-height: 330px">
        <Card :logo="clockIcon" :subtitle="getDate()" color="red" title="Clock Manager">
          <ClockManager :userId="userId" />
            <DailyChart :userId="userId"/>
        </Card>
      </v-col>

      <v-col cols="12" md="6">
        <Card
          :logo="sliceIcon"
          color="green"
          subtitle="Working time"
          title="Working Time Visualization"
        >
          <WorkingTimeVisualization :userId="userId" :workingTimes="workingTimes" />
        </Card>
      </v-col>


      <v-col cols="12" md="6">
        <Card :logo="workIcon" color="yellow" subtitle="Manager" title="Working Time Manager">
          <WorkingTimeManager :userId="userId" @workingTimesUpdated="updateWorkingTimes" />
        </Card>
      </v-col>
      
      <v-col cols="12" md="12">
        <Card :logo="teamIcon" color="orange" subtitle="Team" title="My Team">
          <Team :userId="userId" />
        </Card>
      </v-col>
    </v-row>
  </v-container>
</template>
<style scoped src="./WorkerView.css"></style>