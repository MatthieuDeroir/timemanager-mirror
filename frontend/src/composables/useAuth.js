import { useAuthStore } from '@/store/Auth/AuthStore'
import { useRouter } from 'vue-router'
import { loginUser, logoutUser } from '@/api/AuthAPI.js'
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
    logoutUser()
    authStore.logout()
    router.push('/login')
  }

  const redirectToRoleBasedRoute = (roleId, userId) => {
    const currentRouteParams = router.currentRoute.value.params
    console.log('=>(useAuth.js:58) userId', userId)

    if (!roleId || !userId) {
      router.push('/login')
      return
    }

    switch (roleId) {
      case UserRole.ADMIN:
        router.push(`/admin/${1}`)
        break

      case UserRole.GENERAL_MANAGER:
        if (!currentRouteParams.userId || currentRouteParams.userId !== userId.toString()) {
          router.push(`/general-manager/${userId}`)
        }
        break

      case UserRole.MANAGER:
        if (!currentRouteParams.userId || currentRouteParams.userId !== userId.toString()) {
          router.push(`/manager/${userId}`)
        }
        break

      case UserRole.EMPLOYEE:
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