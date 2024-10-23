<template>
  <v-autocomplete
    :items="userList"
    item-text="username"
    item-title="username"
    item-value="id"
    label="Find an employee"
    style="max-width: 350px"
    @update:model-value="onUserSelected"
  ></v-autocomplete>
</template>

<script lang="ts" setup>
import { computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@store/User/UserStore'
import { useClockStore } from '@store/Clock/ClockStore.js'
import { useWorkingTimeStore } from '@store/WorkingTime/WorkingTimeStore.js'

const router = useRouter()
const userStore = useUserStore()
const clockStore = useClockStore()
const workingTimesStore = useWorkingTimeStore()


const fetchUsers = async () => {
  await userStore.loadAllUsers()
}

const userList = computed(() => userStore.users)

onMounted(async () => {
  await fetchUsers()
})

const onUserSelected = (userId) => {
  clockStore.loadClocks(userId)
  workingTimesStore.loadWorkingTimes(userId)
  router.push({ name: 'Administrator', params: { userId } })
}
</script>

<style scoped>
</style>