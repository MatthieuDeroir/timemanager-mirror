import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '@views/HomeView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/admin/:userId',
      name: 'Home',
      component: HomeView,
      props: route => ({ userId: Number(route.params.userId) }),
      key: route => route.params.userId
    },
    {
      path: '/card',
      name: 'card',
      component: () => import('@components/Card/Card.vue')
    },
    {
      path: '/chartManager/:userid',
      name: 'ChartManager',
      component: () => import('../components/ChartManager/ChartManager.vue')
    }
  ]
})

export default router
