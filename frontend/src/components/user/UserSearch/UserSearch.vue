<template>
  <v-autocomplete
    :items="userList"
    class="user-search"
    item-text="username"
    item-title="username"
    item-value="id"
    label="Find an employee"
    variant="outlined"
    @update:model-value="onUserSelected"
  ></v-autocomplete>
</template>

<script lang="ts" setup>
import { computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@store/User/UserStore'
import { useClockStore } from '@store/Clock/ClockStore.js'
import { useAuthStore } from '@store/Auth/AuthStore.js'
import { useWorkingTimeStore } from '@store/WorkingTime/WorkingTimeStore.js'
import { UserRole } from '@enum/User/UserRole'

const router = useRouter()
const userStore = useUserStore()
const clockStore = useClockStore()
const authStore = useAuthStore()
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
  if (authStore.user.role_id === UserRole.GENERAL_MANAGER) {
    router.push({ name: 'GeneralManager', params: { userId } })
  } else if (authStore.user.role_id === UserRole.ADMIN) {
    router.push({ name: 'Administrator', params: { userId } })
  }
}
</script>

<style src="./UserSearch.css" />
