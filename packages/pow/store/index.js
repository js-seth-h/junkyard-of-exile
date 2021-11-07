import Vue from 'vue'
import Vuex from 'vuex'
// import router from '../router'
// import axios from "axios"

import * as R from 'ramda'

Vue.use(Vuex)

import base_item from '../assets/json/base-item.json'



export default new Vuex.Store({
  state: {


    data:'testststst',
    list_data: [],
    // list_data: {},
    show_data: {}

  },
  mutations: {

    add_item (state, payload) {
      console.log('mutations state', state)
      console.log('mutations payload', payload, 'type=->', typeof payload)
      // let divisions = ['Weapons', 'Rings', 'Amulets', 'Belts', 'Armours', 'Quivers']

      // let division = payload.division
      // if(state.list_data[division] === undefined){
      //     Object.assign(state.list_data, {[division]:[payload]})
      // }else{
      //   state.list_data[division].push(payload)
      // }


      // state.list_data.division[division_item].push(payload)


      console.log('state.list_data', state.list_data)

      // state.list_data[division].push(payload)
      // state.list_data.push(payload)


      // // get img, type id
      // get_item_detail(parsed_item.group[3])
      //
      // let img = {img: 'https://web.poecdn.com/image/Art/2DItems/Weapons/OneHandWeapons/Wands/Wand2.png'}
      // parsed_item = Object.assign(parsed_item);


      console.log('--------------', state.list_data)



      // let data = Object.assign( item_l, payload);
      // let test = Object.assign(payload[0], items)

      state.list_data.push(payload)
      console.log('state.list_data', state.list_data)
    }
  },
  actions: {
     add_item (context, payload) {
         // state로 들어가기 전 모든 값들 assign
         console.log('add item function ->\n','coetext-> ', context, 'payload->', payload)

         // state로 들어가기 전 모든 값들 assign
         // let parsed_item = parse_item(payload)
         //
         // let item_name = parsed_item.group[3]
         // let items = get_item_detail(item_name)
         // console.log('items', items)
         // let test = Object.assign(payload[0], items)
         //
         // console.log('test------------', test)
         // console.log('payload.group[3]', parsed_item.group[3])
         // console.log('payloa1111d', payload)
         // console.log('parsed_item1111', parsed_item)


         // let data = Object.assign(payload[0], {'parsed_items':parsed_item})

         return context.commit('add_item', payload)

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
