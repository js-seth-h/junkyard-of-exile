import Vue from 'vue'
import App from 'pow/app.vue'

import axios from "axios"
Vue.prototype.$http = axios;

import router from './router'

import Vuetify from "vuetify"
import 'vuetify/dist/vuetify.min.css'

import '@fortawesome/fontawesome-free/css/all.css'


import shortid from 'shortid'
import store from './store'

import 'es6-promise/auto'

Vue.config.productionTip = false

// Vue.use(Vuex)
Vue.use( Vuetify )

import ws from 'pow/ws'
import PTF3 from 'ptf3'
import J from 'jsl'

async function readyWebsock() {
  await ws.isReady
  ws.appStart()
  let [data] = await J.waitOnce(ws, 'app-ready')
  let {rule, ref_data} = data
  console.log(rule)
  PTF3.setRefData(rule, ref_data)
  PTF3.setLang('Korean')
  ws.on('add-item', (data)=>{
    console.log({data})
    data.id = shortid.generate()
    store.dispatch('add_item', [data])
    let result = PTF3.parseItemText(data.text)
    console.log('parse ptf3', result)
    let be = PTF3.forBackend(result)
    be.evt = "eval-item"
    ws.sendJSON(be)
  })
  ws.on('eval-result', (data)=>{
    console.log('eval-result',data)
    alert('item evaluated')
  })
}

let v = new Vue({
  vuetify:new Vuetify({
    theme: { dark: true },
    icons: {iconfont: 'fa'},
  }),
  router,
  store,
  render: h => h(App),
  mounted: ()=> {
    readyWebsock()

    // await J.waitOnce(ws, 'app-ready')
    // ws.setStore(store)
  }

}).$mount('#webapp')


// ws.setStore(v.store)


export default v
