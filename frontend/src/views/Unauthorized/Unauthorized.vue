<template>
  <div class="main">
    <h1>Unauthorized</h1>
    <p>You don't have the right to be here.</p>
    <button class="logout-button" @click="redirectToCurrentUserRoute">Return to your route</button>
    <button class="logout-button" @click="handleLogout">Logout</button>
  </div>
</template>

<script setup>
import { useAuth } from '@composables/useAuth.js'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@store/Auth/AuthStore.js'

const { logout, redirectToRoleBasedRoute } = useAuth()
const { user } = useAuthStore()
const router = useRouter()

const handleLogout = () => {
  logout()
}

const redirectToCurrentUserRoute = () => {
  redirectToRoleBasedRoute(user?.role_id, user?.id)
}
</script>

<style>
.main {
  z-index: 1000;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100vh;
  position: relative;
}

.logout-button {
  margin-top: 20px;
  padding: 10px 20px;
  font-size: 16px;
  cursor: pointer;
  background-color: #ff4b5c;
  color: white;
  border: none;
  border-radius: 5px;
  transition: background-color 0.3s ease;
}

.logout-button:hover {
  background-color: #ff1c2a;
}
</style>