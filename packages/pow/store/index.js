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

    add_item (state, payload) {

      state.list_data.push(payload)
      console.log('mutations increment', state.list_data)

    }
  },
  actions: {
    add_item (context, payload) {
      return context.commit('add_item', payload)
    }
  },
  modules: {

  }
})
