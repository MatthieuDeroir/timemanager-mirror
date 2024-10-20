import { useAuthStore } from '@/store/Auth/AuthStore'
import { useRouter } from 'vue-router'
import { loginUser } from '@/api/AuthAPI.js'
import { UserRole } from '@enum/User/UserRole.js'

export function useAuth() {
  const authStore = useAuthStore()
  const router = useRouter()

  const login = async (credentials) => {
    const { user } = await loginUser(credentials)
    const token = localStorage.getItem('TOKEN')
    authStore.login(user, token)
    redirectToRoleBasedRoute(user.role_id, user.id)
  }

  const logout = () => {
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
      case UserRole.ADMIN:
        console.log('Admin')
        router.push(`/admin/${1}`)
        break

      case UserRole.MANAGER:
        console.log('Manager')
        router.push('/manager')
        break

      case UserRole.WORKER:
        console.log('Worker')
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