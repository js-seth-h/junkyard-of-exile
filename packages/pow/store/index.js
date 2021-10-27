import Vue from 'vue'
import Vuex from 'vuex'
// import router from '../router'
// import axios from "axios"

import * as R from 'ramda'

Vue.use(Vuex)

function splited_item(data){
  let item = data[0].text

  if(item.length > 0){
    var blocks = R.map(R.trim, R.split( '--------' ,  item ))
    blocks = R.map( R.split('\n'), blocks )

    for(let data in blocks){
        blocks[data] = R.map( R.split(":"), blocks[data] )
    }
    return blocks
  }else{
    alert('parse item - data is not exist')
  }
}

function parse_item(data){
  console.log('----',data)
  let items = splited_item(data)

  let parsed_items = new Map()
    // 아이템 이름 및 타입
    .set('group',items[0])
    // 아이템 타입 및 데미지
    .set('type',items[1])
    // 무기 요구 레벨 및 스텟
    .set('requirements',items[2])
    // 홈 갯수
    .set('sockets',items[3])
    // 아이템 레벨
    .set('item_level',items[4])
    // 무기 데미지 스텟
    .set('stat',items[5])
    // 무기 추가 데미지 스텟
    .set('add_stat',items[6])
    // 타락, 메모
    .set('unmet',items[7])
    // 스컬지리그 등급 - 앞으로 어떤 값이 추가될지 모름
    .set('leage', items[8])

  console.log('parsed_items', parsed_items)

  return Object.fromEntries(parsed_items)
}


import base_item from '../assets/json/base-item.json'
function get_item_detail(name){
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


function add_item (context, payload){
  // state로 들어가기 전 모든 값들 assign
  let parsed_item = parse_item(payload)

  let item_name = parsed_item.group[3]
   let items = get_item_detail(item_name)
  console.log('items', items)
  let test = Object.assign(payload[0], items)

  console.log('test------------', test)
  // console.log('payload.group[3]', parsed_item.group[3])
  // console.log('payloa1111d', payload)
  // console.log('parsed_item1111', parsed_item)


  let data = Object.assign(payload[0], {'parsed_items':parsed_item})

  return context.commit('add_item', data)
}
export default new Vuex.Store({
  state: {


    data:'testststst',
    // list_data: [],
    list_data: {},
    show_data: {}

  },
  mutations: {

    add_item (state, payload) {
      console.log('payload', payload, 'type=->', typeof payload)
      let division = payload.division
      console.log('division##############', division, 'type=->', typeof division)
      // let divisions = ['Weapons', 'Rings', 'Amulets', 'Belts', 'Armours', 'Quivers']


      if(state.list_data[division] === undefined){
          Object.assign(state.list_data, {[division]:[payload]})
      }else{
        state.list_data[division].push(payload)
      }

      console.log('state.list_data', state.list_data)


      // // get img, type id
      // get_item_detail(parsed_item.group[3])
      //
      // let img = {img: 'https://web.poecdn.com/image/Art/2DItems/Weapons/OneHandWeapons/Wands/Wand2.png'}
      // parsed_item = Object.assign(parsed_item, img);



    }
  },
  actions: {
     add_item: add_item

  },

  modules: {

  }
})
