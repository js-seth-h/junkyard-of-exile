import Vue from 'vue'
import Vuex from 'vuex'
// import router from '../router'
// import axios from "axios"

Vue.use(Vuex)


export default new Vuex.Store({
  state: {


    data:'testststst',
    list_data: [],
    show_data: {}

  },
  mutations: {

    increment (state, payload) {
      state.list_data.push(payload)

    }
  },
  actions: {
    increment (context, payload) {
      context.commit('increment', payload)
    }
  },
  modules: {

  }
})
