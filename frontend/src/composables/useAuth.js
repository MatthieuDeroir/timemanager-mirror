import { useAuthStore } from '@/store/Auth/AuthStore'
import { useRouter } from 'vue-router'
import { loginUser } from '@/api/AuthAPI.js'

export function useAuth() {
  const authStore = useAuthStore()
  const router = useRouter()

  const login = async (credentials) => {
    console.log('Login credentials:', credentials)
    const { user, token } = await loginUser(credentials)
    authStore.login(user, token)
    redirectToRoleBasedRoute(user.role_id, user.id)
    // } catch (error) {
    //   console.error('Login error:', error)
    //   throw new Error('Login failed')
    // }
  }

  const logout = () => {
    logout()
    authStore.logout()
    router.push('/login')
  }

  const redirectToRoleBasedRoute = (roleId, userId) => {
    const currentRouteParams = router.currentRoute.value.params

    if (!roleId || !userId) {
      router.push('/login')
      return
    }

    switch (roleId) {
      case 1:
        router.push(`/admin/${1}`)
        break

      case 2:
        router.push('/manager')
        break

      case 3:
        if (!currentRouteParams.userId || currentRouteParams.userId !== userId.toString()) {
          router.push(`/worker/${userId}`)
        }
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