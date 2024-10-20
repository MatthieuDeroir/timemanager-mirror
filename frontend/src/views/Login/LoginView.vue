<template>
  <Login />
</template>

<script lang="ts" setup>
import { onMounted } from 'vue'
import Login from '@/components/Login/Login.vue'
import { useAuth } from '@/composables/useAuth'
import { useAuthStore } from '@store/Auth/AuthStore'

const { redirectToRoleBasedRoute } = useAuth()
const { user, isAuthenticated } = useAuthStore()

console.log('user dans login view', user)
onMounted(() => {
  if (isAuthenticated) {
    redirectToRoleBasedRoute(user?.role_id, user?.id)
    console.log('auth', isAuthenticated)
  }
})
</script>

<style scoped></style>