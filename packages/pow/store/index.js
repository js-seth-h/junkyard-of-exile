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




function send_server(data_id, payload){
  var obj  = {id: data_id}
  let parsed_data = payload

  // 서버로 보낼 패킷 작성
  obj = Object.assign(obj, PTF.forBackend(parsed_data))

  let res = Object.assign(obj,{'item_data': parsed_data})

  STORE.commit('add_item', res)
  // 전송
  // return bridge.emit('eval-item', obj );
  bridge.emit('eval-item', obj );


  setTimeout(() => {


  let list_data = STORE.state.list_data
  let num = get_position_from_item_id(data_id)

  let rating = rating_extraction(list_data[num].item_data)

  if(rating.includes('?')){
    // setTimeout(() => {bridge.emit('eval-item', obj )}, 1000);
    console.log('???????????????????????????????????????????????????????????????????????????????????')
    bridge.emit('eval-item', obj );
  }

  }, 5000);


}



function rating_extraction(item_data){
  //parced data에서 rating을 추출
  let rating = []

  for(let block in item_data) {
    if(item_data[block].blk_type === 'mod'){

      for (let mod in item_data[block].mods) {
        const cloned = JSON.parse(JSON.stringify(item_data[block].mods[mod]));
        rating.push(item_data[block].mods[mod].rating)
      }
    }
  }
  return rating

}

function get_position_from_item_id( data_id){
  // state.list_data에서 id를 가진 데이터의 배열 번호를 추출하여 반환
  let list_data = STORE.state.list_data
  let num = null
  for(let data in list_data){
    if(data_id === list_data[data].id){
      num = data

    }
  }
  return num
}

bridge.on('eval-result', (evaluate_result) => {
  console.log('evaluate_result', evaluate_result)

  // let rating = rating_extraction(evaluate_result.item_data)
  // evaluate_result.rating = rating

  STORE.dispatch('update_item_by_server', evaluate_result)
})


let STORE = new Vuex.Store({
  state: {


    list_data: [],



  },
  getters: {
    list_data: (state) => {
      return state.list_data;
    }
  },

  mutations: {

    add_item (state, payload) {
      state.list_data.push(payload)
    }
  },
  actions: {
    async update_item_by_server(context, evaluate_result){
      let data_id = evaluate_result.id
      let list_data = context.state.list_data

      // 해당 id를 가지고있는 데이터의 배열 번호 추출
      let num = get_position_from_item_id(data_id)

      let match_key_data = list_data[num]


      // 서버에서 반환된 평가 데이터(Rating)을 아이템 데이터에 반영
      PTF.applyEvaluate(match_key_data.item_data, evaluate_result);

      // 서버에서 반환된 rating 추출
      let rating = rating_extraction(match_key_data.item_data)
      match_key_data.rating = rating

      console.log('match_key_data', match_key_data)
      // # poe 거래소에서 검색
      let trade_result = await(trader.search(match_key_data.item_data));

      // # 거래소 검색 결과를 아이템에 반영
      return PTF.applyTradeResult(match_key_data, trade_result);

    },

     add_item (context, payload) {
       let item_id = shortid.generate()

       return send_server(item_id, payload)


     }

  }
})

export default STORE
