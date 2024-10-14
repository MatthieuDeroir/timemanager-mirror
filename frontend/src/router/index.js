import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '@views/HomeView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView
    },
    {
      path: '/card',
      name: 'card',
      component: () => import('../components/Card/Card.vue')
    },
    {
      path: '/chartManager/:userid',
      name: 'ChartManager',
      component: () => import('../components/ChartManager/ChartManager.vue')
    }
  ]
})

export default router
