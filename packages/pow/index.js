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

import bridge from 'exterra/bridge'
import trader from 'exterra/trader'
import example from 'exterra/example'
import PTF from 'ptf3'
import J from 'jsl'
import DCON_ENV from 'deco-console/env'

async function readyWebsock() {
  DCON_ENV.shorten(function(p) {
    return p.replace(/.+packages\/(.+?)\//, '');
  });
  DCON_ENV.detail(parseInt(process.env.DCON_VERBOSE) || 4);

  DCON_ENV.formatDatetime(process.env.DCON_DT || 'T');


  await bridge.isReady
  bridge.emit('app-start' )
  let [data] = await J.waitOnce(bridge, 'app-ready')
  let {rule, ref_data} = data
  console.log(rule)
  PTF.setRefData(rule, ref_data)
  PTF.setLang('Korean')
  bridge.on('add-item', (data)=>{
    console.log('readyWebsock-> ', {data})
    data.id = shortid.generate()
    let result = PTF.parseItemText(data.text)
    // console.log('parse PTF', result)
    // store.dispatch('add_item', {'item_data': result})
    store.dispatch('add_item', result)
    // let be = PTF.forBackend(result)
    // be.evt = "eval-item"
    // bridge.emit('eval-item', be)
    example.runsExampleCode(data.text)
    // PTF.parseItemText(data.text)
    // bridge.emit( 'eval-item', PTF.forBackend (result))
  })
  // bridge.on('eval-result', (data)=>{
  //   console.log('eval-result',data)
  //   alert('item evaluated')
  // })
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
    // bridge.setStore(store)
  }

}).$mount('#webapp')


// bridge.setStore(v.store)


export default v
