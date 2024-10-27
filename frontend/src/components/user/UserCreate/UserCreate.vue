<template>
  <div class="off-side">
    <Card
      :actionFunction="handleClosePopUp"
      :logo="AddUser"
      actionButton='<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><title>close</title><path d="M19,6.41L17.59,5L12,10.59L6.41,5L5,6.41L10.59,12L5,17.59L6.41,19L12,13.41L17.59,19L19,17.59L13.41,12L19,6.41Z" /></svg>'
      color="purple"
      style="z-index: 10000"
      title="Create user"
    >
      <div class="create-container">
        <form @submit.prevent="handleCreateUser">
          <div class="sections-container">
            <div class="employee-section">
              <div class="input-container">
                <label for="firstname">First Name</label>
                <input id="firstname" v-model="user.firstname" type="text" />
              </div>
              <div class="input-container">
                <label for="lastname">Last Name</label>
                <input id="lastname" v-model="user.lastname" type="text" />
              </div>
              <div class="input-container">
                <label for="address">Address</label>
                <input id="address" v-model="user.address" type="text" />
              </div>
              <div class="input-container">
                <label for="phone">Phone</label>
                <input id="phone" v-model="user.phone" type="text" />
              </div>
              <div class="input-container">
                <label for="birthdate">Birthdate</label>
                <input id="birthdate" v-model="user.birthdate" type="date" />
              </div>
              <div class="input-container">
                <label for="gender">Gender</label>
                <input id="gender" v-model="user.gender" type="text" />
              </div>
              <div class="input-container">
                <label for="username">Username</label>
                <input id="username" v-model="user.username" required type="text" />
              </div>
              <div class="input-container">
                <label for="email">Email</label>
                <input id="email" v-model="user.email" required type="email" />
              </div>
            </div>
            <div class="contract-section">
              <div class="input-container">
                <label for="salary">Salary</label>
                <input id="salary" v-model="user.salary" type="number" />
              </div>
              <div class="input-container">
                <label for="position">Position</label>
                <input id="position" v-model="user.position" type="text" />
              </div>
              <div class="input-container">
                <label for="start_date">Start Date</label>
                <input id="start_date" v-model="user.start_date" type="date" />
              </div>
              <div class="input-container">
                <label for="end_date">End Date</label>
                <input id="end_date" v-model="user.end_date" type="date" />
              </div>
              <div class="input-container">
                <label for="password_hash">Password</label>
                <input id="password_hash" v-model="user.password_hash" required type="password" />
              </div>
              <div class="input-container">
                <label for="role_id">Role</label>
                <input id="role_id" v-model="user.role_id" type="number" />
              </div>
              <div class="input-container">
                <label for="team_id">Team</label>
                <input id="team_id" v-model="user.team_id" type="number" />
              </div>
            </div>
          </div>
          <button class="btn-primary submit-create-user" type="submit">Create User</button>
        </form>
      </div>
    </Card>
  </div>
</template>
<style src="./UserCreate.css"></style>
<script setup>
import {defineEmits, onBeforeUnmount, onMounted, ref} from 'vue'
import Card from '@/components/Card/Card.vue'
import AddUser from '@assets/icons/icons8-add-48.png'
import { useUserStore } from '@store/User/UserStore.js'

const user = ref({
  firstname: '',
  lastname: '',
  address: '',
  phone: '',
  birthdate: '',
  gender: '',
  salary: '',
  position: '',
  start_date: '',
  end_date: '',
  username: '',
  email: '',
  password_hash: '',
  role_id: '',
  team_id: ''
})

const userStore = useUserStore()
const emit = defineEmits(['closePopUp'])

const handleClosePopUp = () => {
  emit('closePopUp')
}

async function handleCreateUser() {
  const response = await userStore.createUser(user)
}

const handleEscKey = (event) => {
  if (event.key === 'Escape' || event.key === 'Esc') {
    handleClosePopUp();
  }
};

onMounted(() => {
  document.addEventListener('keydown', handleEscKey);
});

onBeforeUnmount(() => {
  document.removeEventListener('keydown', handleEscKey);
});
</script>