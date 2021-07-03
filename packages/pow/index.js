import Vue from 'vue'
import App from 'pow/app.vue'
import axios from "axios"
import router from './router'
Vue.prototype.$http = axios;

import Vuetify from "vuetify"
import 'vuetify/dist/vuetify.min.css'

import Vuex from 'vuex'

import 'es6-promise/auto'

// import Vuetify from "vuetify/lib/framework"
// import * as components from "vuetify/lib/components"
// import * as directives from "vuetify/lib/directives"


Vue.config.productionTip = false

Vue.use(Vuex)
Vue.use( Vuetify )

// Vue.use( Vuetify, {
//   components: components,
//   directives: directives
// })


new Vue({
  vuetify:new Vuetify({
    theme: { dark: true },
  }),
  router,
  render: h => h(App)
}).$mount('#webapp')
