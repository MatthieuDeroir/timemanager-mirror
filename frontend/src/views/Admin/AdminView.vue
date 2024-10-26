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
import logsIcon from '@assets/icons/icons8-log-48.png'
import calendarIcon from '@assets/icons/icons8-mail-48.png'
import Team from '@components/Team/Team.vue'
import UserDisplay from '@components/user/UserDisplay/UserDisplay.vue'
import UserCreate from '@components/user/UserCreate/UserCreate.vue'
import LogsComponent from '@components/LogsComponenet/Logs.vue'
import Calendar from '@/components/Calendar.vue'
import DayliChart from '@components/Chart/DailyChart.vue'

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
    <UserCreate @closePopUp="handleClosePopUp"></UserCreate>
  </div>
  <v-container class="padding-top-view">
    <v-row>
      <v-col cols="12" md="5">
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

      <v-col cols="12" md="7">
        <Card :logo="teamIcon" color="orange" title="All Teams">
          <Team />
        </Card>
      </v-col>

      <v-col cols="12" md="5" style="min-height: 330px">
        <Card
          :logo="sliceIcon"
          color="green"
          :subtitle="userTitle"
          title="Working Time Visualization"
        >
          <WorkingTimeVisualization :userId="userId" :workingTimes="workingTimes" />
        </Card>
      </v-col>

      <v-col cols="12" md="7">
        <Card :logo="workIcon" :subtitle="userTitle" color="yellow" title="Working Time Manager">
          <WorkingTimeManager :userId="userId" @workingTimesUpdated="updateWorkingTimes" />
        </Card>
      </v-col>

      <v-col cols="12" md="12">
        <Card :logo="logsIcon" color="pink" subtitle="Users Logs" title="Users Logs">
          <LogsComponent />
        </Card>
      </v-col>

      <v-col cols="12" md="12">
        <Card :logo="calendarIcon" color="purple" title="Calendar" subtitle="test">
          <Calendar :userId="userId" />
        </Card>
      </v-col>
    </v-row>
  </v-container>
</template>
<style scoped src="./AdminView.css"></style>
