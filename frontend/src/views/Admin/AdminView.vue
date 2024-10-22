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
import teamIcon from '@assets/icons/icons8-team-48.png'
import calendarIcon from '@assets/icons/icons8-mail-48.png'
import Team from '@components/Team/Team.vue'
import UserDisplay from '@components/user/UserDisplay/UserDisplay.vue'
import UserCreate from '@components/user/UserCreate/UserCreate.vue'
import Calendar from '@/components/Calendar.vue'

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
const createUserPopUp = ref(false)
const handleOpenPopUpCreateUser = () => {
  createUserPopUp.value = true
  document.body.style.overflow = 'hidden'
}
const handleClosePopUp = () => {
  createUserPopUp.value = false
  document.body.style.overflow = 'auto'
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
  <div v-if="createUserPopUp">
    <UserCreate @clickOut="handleClosePopUp"></UserCreate>
  </div>
  <v-container class="padding-top-view">
    <v-row>
      <v-col cols="12" md="4">
        <Card
          :actionFunction="handleOpenPopUpCreateUser"
          :logo="userIcon"
          :otherInfo="userGender"
          :subtitle="userSubtitle"
          :title="userTitle"
          actionButton='<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><title>plus</title><path d="M19,13H13V19H11V13H5V11H11V5H13V11H19V13Z" /></svg>'
          color="blue"
        >
          <UserDisplay :userId="userId" @selecteduser="handleSelectedUser" />
        </Card>
      </v-col>

      <v-col cols="12" md="8">
        <Card
          :logo="sliceIcon"
          color="green"
          subtitle="Working time"
          title="Working Time Visualization"
        >
          <WorkingTimeVisualization :userId="userId" :workingTimes="workingTimes" />
        </Card>
      </v-col>

      <v-col cols="12" md="4" style="min-height: 330px">
        <Card :logo="clockIcon" :subtitle="getDate()" color="red" title="Clock Manager">
          <ClockManager :userId="userId" />
          <!--          TODO : Fix daily chart to use store-->
          <!--          <DayliChart :userId="userId"/>-->
        </Card>
      </v-col>

      <v-col cols="12" md="8">
        <Card :logo="workIcon" :subtitle="userTitle" color="yellow" title="Working Time Manager">
          <WorkingTimeManager :userId="userId" @workingTimesUpdated="updateWorkingTimes" />
        </Card>
      </v-col>

      <v-col cols="12" md="12">
        <Card :logo="teamIcon" color="orange" subtitle="Team" title="My Team">
          <Team :userId="userId" />
        </Card>
      </v-col>

      <v-col cols="12" md="12">
        <Card :logo="calendarIcon" color="purple" title="Calendar" subtitle="test">
          <Calendar :userId="userId"/>
        </Card>
      </v-col>
    </v-row>
  </v-container>
</template>
<style scoped src="./AdminView.css"></style>