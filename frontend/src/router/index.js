import { createRouter, createWebHistory } from 'vue-router'
import AdminView from '@views/Admin/AdminView.vue'
import ManagerView from '@views/Manager/ManagerView.vue'
import WorkerView from '@views/Worker/WorkerView.vue'
import NotFound from '@views/NotFound/NotFound.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/admin/:userId',
      name: 'Administrator',
      component: AdminView,
      props: (route) => ({ userId: Number(route.params.userId) }),
      key: (route) => route.params.userId
    },
    {
      path: '/manager',
      name: 'Manager',
      component: ManagerView
    },
    {
      path: '/worker',
      name: 'Worker',
      component: WorkerView
    },
    {
      path: '/:pathMatch(.*)*',
      name: 'NotFound',
      component: NotFound
    }
  ]
})

export default router