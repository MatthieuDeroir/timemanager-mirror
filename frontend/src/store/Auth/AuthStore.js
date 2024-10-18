import { defineStore } from 'pinia'
import { computed, ref } from 'vue'

export const useAuthStore = defineStore('auth', () => {
  const user = ref(JSON.parse(localStorage.getItem('CURRENT_USER')) || null)
  const token = ref(localStorage.getItem('TOKEN') || null)

  const login = (userData, userToken) => {
    user.value = userData
    token.value = userToken

    localStorage.setItem('CURRENT_USER', JSON.stringify(userData))
    localStorage.setItem('TOKEN', userToken)
  }

  const logout = () => {
    user.value = null
    token.value = null

    localStorage.removeItem('CURRENT_USER')
    localStorage.removeItem('TOKEN')
  }

  const isAuthenticated = () => {
    return !!token.value
  }

  const role = computed(() => user.value?.role)

  return { user, token, role, login, logout, isAuthenticated }
})