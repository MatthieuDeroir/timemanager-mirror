import { useAuthStore } from '@/store/Auth/AuthStore'
import { useRouter } from 'vue-router'

export function useAuth() {
  const authStore = useAuthStore()
  const router = useRouter()

  const login = async (credentials) => {
    try {
      const fakeApiCall = new Promise((resolve) => {
        setTimeout(() => {
          resolve({
            user: { id: 1, name: 'John Doe', role: 'admin' },
            token: 'fake-jwt-token'
          })
        }, 1000)
      })

      const { user, token } = await fakeApiCall

      authStore.login(user, token)
      redirectToRoleBasedRoute(user.role, user.id)
    } catch (error) {
      console.error('Login error:', error)
      throw new Error('Login failed')
    }
  }

  const logout = () => {
    authStore.logout()
    router.push('/login')
  }

  const redirectToRoleBasedRoute = (role, userId) => {
    if (!role || !userId) {
      router.push('/login')
      return
    }

    switch (role) {
      case 'admin':
        router.push(`/admin/${1}`)
        break
      case 'manager':
        router.push('/manager')
        break
      case 'worker':
        router.push(`/worker/${userId}`)
        break
      default:
        router.push('/unauthorized')
    }
  }

  return {
    login,
    logout,
    redirectToRoleBasedRoute
  }
}