import Vue from 'vue'
import Vuex from 'vuex'
// import router from '../router'
// import axios from "axios"

import R from 'ramda'
import RA from 'ramda-adjunct'


import bridge from 'exterra/bridge.coffee'

import trader from 'exterra/trader.coffee'
import PTF from 'ptf3/index.coffee'
import shortid from 'shortid'


Vue.use(Vuex)

import base_item from '../assets/json/base-item.json'



function send_server(data_id, payload){
  var obj  = {id: data_id}
  obj = Object.assign(obj, PTF.forBackend(payload))
  console.log('-------------obj', obj)

  let res = Object.assign(obj,{'item_data': payload})
  STORE.commit('add_item', res)

  return bridge.emit('eval-item', obj );
}



bridge.on('eval-result', (evaluate_result) => {
  STORE.dispatch('update_item_by_server', evaluate_result)
})


let STORE = new Vuex.Store({
  state: {


    data:'testststst',
    list_data: [],



  },
  mutations: {

    add_item (state, payload) {
      state.list_data.push(payload)
      console.log('state', state)
      console.log('state.list_data', state.list_data)
    }
  },
  actions: {
    async update_item_by_server(context, evaluate_result){
      // bridge.on('eval-result', async (evaluate_result) =>{
        console.log('!!!!!!!!!!!!!!!!!!!!!!evaluate_result', evaluate_result)
      console.log('!!!!!!!!!!!!!!!!!this.store', context.state.list_data)
        let data_id = evaluate_result.id
      console.log('data_id')

        let num = null
        for(let data in context.state.list_data){
          console.log('data',data)
          if(data_id === context.state.list_data[data].id){
            console.log('data', data)
            num = data

          }
        }

        let match_key_data = context.state.list_data[num]
        PTF.applyEvaluate(match_key_data.item_data, evaluate_result);
        let trade_result = await(trader.search(match_key_data.item_data));
        //
        console.log('trade_result---', trade_result)

        return PTF.applyTradeResult(match_key_data, trade_result);
      // })

    },
     add_item (context, payload) {
       let item_id = shortid.generate()
       // state로 들어가기 전 모든 값들 assign
       console.log('add item function ->\n','coetext-> ', context, 'payload->', payload)

       return send_server(item_id, payload)


     }

  },

  modules: {

    get_item_detail(name){
      let res = {img:'', division: ''}
      // console.log('base_item', base_item)
      for(let data of base_item){
        // console.log('data', data)
        for(const [key, value] of Object.entries(data)){
          if(name.toString() === value){
            console.log('get_item_detail res ', data.img_url, data.id)

            res.img = data.img_url
            res.division = data.id
          }
        }
      }

      let splited_division = res.division.split('/')
      res.division  = splited_division[2]

      return res
    }

  }
})

export default STORE
