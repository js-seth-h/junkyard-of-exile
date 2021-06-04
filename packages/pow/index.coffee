
import Vue from "vue"
import App from './app.vue'
import VueRouter from 'vue-router'
Vue.use VueRouter

main = ()->

  # pxcio.recoveryAuth()
  mounter = new Vue App

  mounter.$mount('#webapp')
  # if (new URL location.href).searchParams.has('forManifesto')
  #   await J.postpone '1s'
  #   window.close()

main()
