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


let parsed_obj = null;

function send_server(payload){
  return bridge.emit('eval-item', PTF.forBackend(payload));
}

bridge.on('eval-result', async (evaluate_result) =>{
  PTF.applyEvaluate(parsed_obj, evaluate_result);
  let trade_result = await(trader.search(parsed_obj));

  return PTF.applyTradeResult(parsed_obj, trade_result);
})


export default new Vuex.Store({
  state: {


    data:'testststst',
    list_data: [],
    // list_data: {},
    show_data: {}

  },
  mutations: {

    add_item (state, payload) {
      console.log('mutations payload', payload, 'type=->', typeof payload)
      state.list_data.push(payload)
    }
  },
  actions: {
     add_item (context, payload) {
       // state로 들어가기 전 모든 값들 assign
       console.log('add item function ->\n','coetext-> ', context, 'payload->', payload)

       send_server(payload)
       parsed_obj = payload;
       let res = {'item_data': payload}

       Object.assign(res, {item_id: shortid.generate()});


       return context.commit('add_item', res)

     }

  },

  modules: {
    rating_extraction(data){
      //parced data에서 rating을 추출
      let rating = []
      for(let block in data) {
        for (let data in data[block]) {
          if(data[block].blk_type === 'mod'){

            for (let mod in data[block].mods) {
              rating.push(data[block].mods[mod].rating)
            }
          }
        }
      }

      console.log('++++++++++++++++++++++++rating', rating)
    },
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
