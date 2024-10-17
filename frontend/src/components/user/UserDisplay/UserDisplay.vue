<template>
  <div v-if="loading">
    <LoaderComponent></LoaderComponent>
  </div>
  <div v-else class="user-tile">
    <div class="category">
      <div class="title">Employee</div>
      <div class="infos">
        <div class="label">Birthdate: &nbsp;</div>
        <div>{{ user.birthdate }}</div>
      </div>
      <div class="infos">
        <div class="label">Phone: &nbsp;</div>
        <div>{{ user.phone }}</div>
      </div>
      <div class="infos">
        <div class="label">Address: &nbsp;</div>
        <div>{{ user.address }}</div>
      </div>
      <div class="infos">
        <div class="label">Username: &nbsp;</div>
        <div>{{ user.username }}</div>
      </div>
    </div>
    <div class="category">
      <div class="title">Contract</div>
      <div class="infos">
        <div class="label">Salary: &nbsp;</div>
        <div>{{ user.salary }} hints/month</div>
      </div>
      <div class="infos">
        <div class="label">Position: &nbsp;</div>
        <div>{{ user.position }}</div>
      </div>
      <div class="infos">
        <div class="label">Start Date: &nbsp;</div>
        <div>{{ user.start_date }}</div>
      </div>
      <div class="infos">
        <div class="label">End Date: &nbsp;</div>
        <div>{{ user.end_date }}</div>
      </div>
    </div>
  </div>
</template>
<style src="./UserDisplay.css"></style>
<script setup>
import { onMounted, ref, watch } from 'vue'
import LoaderComponent from '@components/Loader/LoaderComponent.vue'
import { getUserById } from '@/api/userServices.js'

const props = defineProps({
  userId: {
    type: Number,
    required: true
  }
})
const loading = ref({})
const user = ref({})
const emit = defineEmits(['selecteduser'])
const fetchUser = async (userId) => {
  user.value = await getUserById(userId)
  user.value.birthdate = new Date(user.value.birthdate).toLocaleDateString('en-GB', {
    day: '2-digit',
    month: 'long',
    year: 'numeric'
  })
  user.value.start_date = new Date(user.value.start_date).toLocaleDateString('en-GB', {
    day: '2-digit',
    month: 'long',
    year: 'numeric'
  })
  user.value.end_date = new Date(user.value.end_date).toLocaleDateString('en-GB', {
    day: '2-digit',
    month: 'long',
    year: 'numeric'
  })
  loading.value = false
  emit('selecteduser', user.value)
}

onMounted(() => {
  loading.value = true
  fetchUser(props.userId)
})

watch(
  () => props.userId,
  (newUserId) => {
    fetchUser(newUserId)
  }
)

const editUser = () => {
  console.log('Modifier l’utilisateur')
}

const deleteUser = () => {
  console.log('Supprimer l’utilisateur')
}
</script>