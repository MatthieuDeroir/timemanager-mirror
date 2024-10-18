import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '@/store/Auth/AuthStore'
import AdminView from '@views/Admin/AdminView.vue'
import ManagerView from '@views/Manager/ManagerView.vue'
import WorkerView from '@views/Worker/WorkerView.vue'
import NotFound from '@views/NotFound/NotFound.vue'
import Unauthorized from '@views/Unauthorized.vue'
import LoginView from '@views/Login/LoginView.vue'

const routes = [
  {
    path: '/',
    redirect: '/login'
  },
  {
    path: '/admin/:userId',
    name: 'Administrator',
    component: AdminView,
    props: (route) => ({ userId: Number(route.params.userId) }),
    key: (route) => route.params.userId,
    meta: { requiresAuth: true, role: 'admin' }
  },
  {
    path: '/manager',
    name: 'Manager',
    component: ManagerView,
    meta: { requiresAuth: true, role: 'manager' }
  },
  {
    path: '/worker/:userId',
    name: 'Worker',
    component: WorkerView,
    props: (route) => ({ userId: Number(route.params.userId) }),
    key: (route) => route.params.userId,
    meta: { requiresAuth: true, role: 'worker' }
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
    meta: { hideNavbar: true }
  },
  {
    path: '/:pathMatch(.*)*',
    name: 'NotFound',
    component: NotFound,
    meta: { hideNavbar: true }
  }
]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes
})

router.beforeEach((to, from, next) => {
  const authStore = useAuthStore()

  if (to.meta.requiresAuth) {
    if (!authStore.isAuthenticated()) {
      return next('/login')
    }

    const userRole = authStore.user?.role
    if (to.meta.role && to.meta.role !== userRole) {
      return next('/unauthorized')
    }
  }
  next()
})

export default router