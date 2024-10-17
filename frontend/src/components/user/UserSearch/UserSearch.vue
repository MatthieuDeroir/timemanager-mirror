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

const emit = defineEmits(['user-selected'])
const router = useRouter()
const store = useUserStore()

const fetchUsers = async () => {
  await store.loadAllUsers()
}

const userList = computed(() => store.users)

onMounted(async () => {
  await fetchUsers()
})

const onUserSelected = (userId) => {
  router.push({ name: 'Administrator', params: { userId } })
}
</script>

<style scoped>
.custom-autocomplete .v-input_control {
}
</style>