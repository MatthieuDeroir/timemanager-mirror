<template>
  <v-autocomplete
    :items="userList"
    item-text="username"
    item-title="username"
    item-value="id"
    label="Find an employee"
    variant="outlined"
    @update:model-value="onUserSelected"
  ></v-autocomplete>
</template>

<script lang="ts" setup>
import { computed, defineEmits, defineProps, onMounted } from 'vue'
import { useUserStore } from '@store/User/UserStore'
import { useTeamStore } from '@store/Team/TeamStore.js'

const userStore = useUserStore()
const teamStore = useTeamStore()

const props = defineProps({
  team_id: Number
})
const emit = defineEmits(['onUserAddedToTeam'])

const fetchUsers = async () => {
  await userStore.loadAllUsers()
}

const userList = computed(() => userStore.users)

onMounted(async () => {
  await fetchUsers()
})

const onUserSelected = (user_id) => {
  teamStore.addUserInTeam(user_id, props.team_id)
  emit('onUserAddedToTeam')
}
</script>

<style scoped></style>
