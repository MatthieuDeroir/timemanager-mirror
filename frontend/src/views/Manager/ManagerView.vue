<script setup>
import { ref, computed } from 'vue'
import WorkingTimeManager from '@components/WorkingTimeManager/WorkingTimeManager.vue'
import WorkingTimeVisualization from '@components/WorkingTimeVisualization/WorkingTimeVisualization.vue'
import Card from '@components/Card/Card.vue'
import userIcon from '@assets/icons/icons8-user-48.png'
import workIcon from '@assets/icons/icons8-work-48.png'
import sliceIcon from '@assets/icons/icons8-slice-48.png'
import UserDisplay from '@components/user/UserDisplay/UserDisplay.vue'
import UserCreate from '@components/user/UserCreate/UserCreate.vue'
import Team from '@components/Team/Team.vue'
import teamIcon from '@assets/icons/icons8-team-48.png'
import { useAuthStore } from '@store/Auth/AuthStore.js'

const props = defineProps({
  userId: {
    type: Number,
    required: true
  },
  workerId: {
    type: Number
  }
})
const authStore = useAuthStore()
const userTitle = ref('User Info')
const userSubtitle = ref('User Information')
const userGender = ref('User Information')
const worker =  computed(()=>props.workerId === 0 ? props.userId : props.workerId);
console.log(worker.value)


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
      <v-col cols="12" md="6">
        <Card :logo="teamIcon" color="orange" subtitle="Team" title="My Team">
          <Team :userId="userId" />
        </Card>
      </v-col>
      <v-col cols="12" md="6">
        <Card
          :logo="sliceIcon"
          color="green"
          :subtitle="userTitle"
          title="Working Time Visualization"
        >
          <WorkingTimeVisualization :userId="worker" :workingTimes="workingTimes" />
        </Card>
      </v-col>
      <v-col cols="12" md="4">
        <Card
          :logo="userIcon"
          :otherInfo="userGender"
          :subtitle="userSubtitle"
          :title="userTitle"
          color="blue"
        >
          <UserDisplay :userId="worker" @selecteduser="handleSelectedUser" />
        </Card>
      </v-col>


      <v-col cols="12" md="8">
        <Card :logo="workIcon" color="yellow" :subtitle="userTitle" title="Working Time Manager">
          <WorkingTimeManager :userId="worker" @workingTimesUpdated="updateWorkingTimes" />
        </Card>
      </v-col>
    </v-row>
  </v-container>
</template>
<style scoped src="./ManagerView.css"></style>