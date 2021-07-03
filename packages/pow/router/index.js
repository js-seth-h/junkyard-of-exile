import Vue from 'vue'
import VueRouter from 'vue-router'
import app from '../app.vue'
import app2 from '../views/app2.vue'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'app2',
    component: app2
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
