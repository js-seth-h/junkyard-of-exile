import Vue from 'vue'
import App from 'pow/app.vue'

import axios from "axios"
Vue.prototype.$http = axios;

import router from './router'

import Vuetify from "vuetify"
import 'vuetify/dist/vuetify.min.css'

import '@fortawesome/fontawesome-free/css/all.css'


import store from './store'

import 'es6-promise/auto'

Vue.config.productionTip = false

// Vue.use(Vuex)
Vue.use( Vuetify )

import ws from 'pow/ws'


let v = new Vue({
  vuetify:new Vuetify({
    theme: { dark: true },
    icons: {iconfont: 'fa'},
  }),
  router,
  store,
  render: h => h(App),
  mounted: ()=> {
    ws.on('add-item', (data)=>{
      store.dispatch('add_item', [data])
    })
    // await J.waitOnce(ws, 'app-ready')
    // ws.setStore(store)
  }

}).$mount('#webapp')


// ws.setStore(v.store)


export default v
