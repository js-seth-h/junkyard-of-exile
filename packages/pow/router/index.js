import Vue from 'vue'
import VueRouter from 'vue-router'
// import app from '../app.vue'
import app from '../views/app.vue'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'app',
    component: app
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
