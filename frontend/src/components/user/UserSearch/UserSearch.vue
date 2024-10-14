<template>
  <v-autocomplete
      style="max-width: 350px;"
      :items="userList"
      item-text="username"
      item-title="username"
      item-value="id"
      label="Find an employee"
      @update:model-value="onUserSelected"
  ></v-autocomplete>
</template>

<script lang="ts" setup>
import {computed, onMounted, ref} from 'vue'
import {getAllUsers} from '@services/userServices'
import { useRouter } from 'vue-router';

const emit = defineEmits(['user-selected'])
const router = useRouter();
const users = ref([])

const fetchUsers = async () => {
  users.value = await getAllUsers()
}

const userList = computed(() => users.value)

onMounted(async () => {
  await fetchUsers()
})

const onUserSelected = (userId) => {
  router.push({ name: 'Home', params: { userId } });
}
</script>
<style scoped>
.custom-autocomplete .v-input_control {
  /* Your custom styles here */
}
</style>