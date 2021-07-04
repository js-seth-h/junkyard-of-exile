import Vue from 'vue'
import App from 'pow/app.vue'

import axios from "axios"
Vue.prototype.$http = axios;

import router from './router'

import Vuetify from "vuetify"
import 'vuetify/dist/vuetify.min.css'


import store from './store'

import 'es6-promise/auto'

Vue.config.productionTip = false

// Vue.use(Vuex)
Vue.use( Vuetify )

new Vue({
  vuetify:new Vuetify({
    theme: { dark: true },
  }),
  router,
  store,
  render: h => h(App)
}).$mount('#webapp')
