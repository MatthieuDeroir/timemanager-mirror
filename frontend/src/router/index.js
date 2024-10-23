import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '@/store/Auth/AuthStore'
import AdminView from '@views/Admin/AdminView.vue'
import ManagerView from '@views/Manager/ManagerView.vue'
import WorkerView from '@views/Worker/WorkerView.vue'
import NotFound from '@views/NotFound/NotFound.vue'
import Unauthorized from '@views/Unauthorized/Unauthorized.vue'
import LoginView from '@views/Login/LoginView.vue'
import { UserRole } from '@enum/User/UserRole.js'

const routes = [
  {
    path: '/',
    redirect: '/login'
  },
  {
    path: '/admin/:userId(\\d+)',
    name: 'Administrator',
    component: AdminView,
    props: (route) => ({ userId: Number(route.params.userId) }),
    key: (route) => route.params.userId,
    meta: { requiresAuth: true, role: UserRole.ADMIN }
  },
  {
    path: '/general-manager/:userId(\\d+)',
    name: 'GeneralManager',
    component: ManagerView,
    props: (route) => ({ userId: Number(route.params.userId) }),
    key: (route) => route.params.userId,
    meta: { requiresAuth: true, role: UserRole.GENERAL_MANAGER }
  },
  {
    path: '/manager/:userId(\\d+)',
    name: 'Manager',
    component: ManagerView,
    props: (route) => ({ userId: Number(route.params.userId) }),
    key: (route) => route.params.userId,
    meta: { requiresAuth: true, role: UserRole.MANAGER }
  },
  {
    path: '/worker/:userId(\\d+)',
    name: 'Worker',
    component: WorkerView,
    props: (route) => ({ userId: Number(route.params.userId) }),
    key: (route) => route.params.userId,
    meta: { requiresAuth: true, role: UserRole.EMPLOYEE }
  },
  {
    path: '/login',
    name: 'Login',
    component: LoginView,
    meta: { hideNavbar: true }
  },
  {
    path: '/unauthorized',
    name: 'Unauthorized',
    component: Unauthorized,
    meta: { hideNavbar: true, requiresAuth: true }
  },
  {
    path: '/:pathMatch(.*)*',
    name: 'NotFound',
    component: NotFound,
    meta: { hideNavbar: true, requiresAuth: true }
  }
]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes
})

router.beforeEach((to, from, next) => {
  const authStore = useAuthStore()

  if (to.meta.requiresAuth) {
    if (!authStore.isAuthenticated) {
      return next('/login')
    }

    const userRole = authStore.user.role_id
    const userId = authStore.user?.id

    if (to.meta.role && to.meta.role !== userRole) {
      return next('/unauthorized')
    }

    if (userRole === 'worker' && to.params.userId !== userId.toString()) {
      return next(`/worker/${userId}`)
    }
  }

  next()
})

export default router