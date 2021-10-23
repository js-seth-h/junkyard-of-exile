import Vue from 'vue'
import Vuex from 'vuex'
// import router from '../router'
// import axios from "axios"

import * as R from 'ramda'

Vue.use(Vuex)

function splited_item(data){
  let item = data[0].text

  if(item.length > 0){
    // R.replace('\r',''),
    var blocks = R.map(R.trim, R.split( '--------' ,  item ))
    blocks = R.map( R.split('\n'), blocks )
    // blocks = R.map( R.split(':'), blocks)

    for(let data in blocks){
      // console.log('!!!!!!!!!!!data', data)
      // for(let child_data of  blocks[data]){
      //   blocks[data].replace(/[\r]*/g,'')

        blocks[data] = R.map( R.split(":"), blocks[data] )

        // console.log(child_data)
      // }
    }
    console.log('blocks:: ', blocks)

    // var clone = {};
    // for (const key in item) {
    //   if (typeof item[key] == "object" && item[key] != null) {
    //     clone[key] = R.map( R.split('\n'), item)
    //   } else {
    //     clone[key] = item[key];
    //   }
    // }
    // console.log('clone---', clone)
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


  // let test_parsed_items = items
  // test_parsed_items.map((v) => {
  //   console.log('test_parsed_items v', v)
  //
  // });
  // console.log('test_parsed_items000', test_parsed_items)


  console.log('parsed_items', parsed_items)

  return Object.fromEntries(parsed_items)
}

function add_item (context, payload){
  let parsed_item = parse_item(payload)

  let data = Object.assign(payload[0], {'parsed_items':parsed_item})

  return context.commit('add_item', data)
}
export default new Vuex.Store({
  state: {


    data:'testststst',
    list_data: [],
    show_data: {}

  },
  mutations: {

    add_item (state, payload) {
      console.log('payload', payload)
      state.list_data.push(payload)
      console.log('mutations increment', state.list_data)

    }
  },
  actions: {
     add_item: add_item

  },

  modules: {

  }
})
