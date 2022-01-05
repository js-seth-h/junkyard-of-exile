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


function add_error(result){
  let exist = false
  let num = 1
  let error_data_test = {
    id : result.id,
    num: num
  }

  let exit_electron = false


  STORE.state.error_occurred.map((val, inx) =>{
    if(val.id === result.id){
      console.log('error is exist')
      val.num  = val.num + 1
      exist = true
    }
    if(val.num >= 3){

      // alert('error is bigger then 3')
      console.log('error is bigger then 3',val.num)
      // exist = true
    }
  })

  if(!exist){
    let error_data = {
      id : result.id,
      num: num
    }

    STORE.state.error_occurred.push(error_data)
  }
  console.log('STORE.state.error_occurred3', STORE.state.error_occurred)
  // console.log('test',  STORE.state.error_occurred)


}


function server_eval_item(res, obj){

  let list_data = STORE.state.list_data
  let stat  = true
  list_data.map(x => {
    if(x.id === obj.id){
      console.log('res: ', res, 'obj: ', obj)
      console.log('동일한 id 입니다')
      stat = false
      x = res

    }
  })

  STORE.state.list_data = list_data

  console.log('eval_list_data', list_data)
  console.log('eval_list_data', STORE.state.list_data)

  if(stat){
    STORE.commit('add_item', res)
  }

  bridge.emit('eval-item', obj );

  let error_stat = false
  setTimeout(() => {


    // let result = get_position_from_item_id(data_id)
    let result = get_position_from_item_id(obj.id)
    let error_stat = false
    if(rating_extraction(result.item_data).includes('?')){
      // setTimeout(() => {bridge.emit('eval-item', obj )}, 1000);
      console.log('???????????????????????????????????????????????????????????????????????????????????', result)

      add_error(result)

      error_stat = true

      // bridge.emit('eval-item', obj );
    }else{
      list_data.map(x=>{
        if(x.id === obj.id){
          x.item_data = result.item_data
        }
      })
    }


    console.log('error_stat', error_stat)
    if(error_stat){
      server_eval_item(res, obj)
    }

  }, 3000);


}

function send_server(data_id, payload){
  var obj  = {id: data_id}
  let parsed_data = payload

  // 서버로 보낼 패킷 작성
  obj = Object.assign(obj, PTF.forBackend(parsed_data))

  let res = Object.assign(obj,{'item_data': parsed_data})

  server_eval_item(res, obj)

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
  return list_data.find((el)=> el.id === data_id)

}

bridge.on('eval-result', (evaluate_result) => {
  console.log('evaluate_result', evaluate_result)

  STORE.dispatch('update_item_by_server', evaluate_result)
})


let STORE = new Vuex.Store({
  state: {

    error_occurred:[],
    list_data: [],
    trade_data2:{
      use:[
        {
          id: 'test1',
          name:'용의 파괴자 카루이 절단기 1',
          process:'done',
          status: true,
        },
        {
          id: 'test2',
          name:'태풍 꼬챙이 원석 검 2',
          process:'ing',
          status: true,
        },
        {
          id: 'test4',
          name:'강풍의 꼬임 성채 활 4',
          process:'before',
          status: true,
        },
      ],
      unused:[
        {
          id: 'test3',
          name:'마음의 바늘 아로새긴 마법봉 3',
          process:'before',
          status: false,
        },
        {
          id: 'test5',
          name:'슬픔의 갈망 에조미어 도끼 5',
          process:'before',
          status: false,
        },
        {
          id: 'test6',
          name:'슬픔의 갈망 에조미어 도끼 6',
          process:'before',
          status: false,
        },
        {
          id: 'test7',
          name:'슬픔의 갈망 에조미어 도끼 7',
          process:'before',
          status: false,
        }
      ],
    },
    trade_data: [
      {
        id: 'test1',
        name:'용의 파괴자 카루이 절단기 1',
        process:'done',
        status: true,
      },
      {
        id: 'test2',
        name:'태풍 꼬챙이 원석 검 2',
        process:'ing',
        status: true,
      },
      {
        id: 'test3',
        name:'마음의 바늘 아로새긴 마법봉 3',
        process:'before',
        status: false,
      },
      {
        id: 'test4',
        name:'강풍의 꼬임 성채 활 4',
        process:'before',
        status: true,
      },
      {
        id: 'test5',
        name:'슬픔의 갈망 에조미어 도끼 5',
        process:'before',
        status: false,
      },
      {
        id: 'test6',
        name:'슬픔의 갈망 에조미어 도끼 6',
        process:'before',
        status: false,
      },
      {
        id: 'test7',
        name:'슬픔의 갈망 에조미어 도끼 7',
        process:'before',
        status: false,
      }

    ],



  },
  getters: {
    list_data: (state) => {
      return state.list_data;
    },
    trade_data: (state) => {
      return state.trade_data;
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
      let trade_data = context.state.trade_data

      // 해당 id를 가지고있는 데이터의 배열 번호 추출
      let result = get_position_from_item_id(data_id)

      let match_key_data = result


      // 서버에서 반환된 평가 데이터(Rating)을 아이템 데이터에 반영
      PTF.applyEvaluate(match_key_data.item_data, evaluate_result);

      // 서버에서 반환된 rating 추출
      let rating = rating_extraction(match_key_data.item_data)
      match_key_data.rating = rating

      console.log('trade****************', match_key_data)
      // let trade_list = trade_data
      let trade = {}
      trade.id = match_key_data.id
      trade.status = false
      trade.name = match_key_data.item_data.header.name + ' '+ match_key_data.item_data.header.base_type
      trade_data.push(trade)
      console.log('trade%%%%%%%',trade)
      console.log('trade_data%%%%%%%',trade_data)

      console.log('match_key_data', match_key_data)
      // # poe 거래소에서 검색
      let trade_result = await(trader.search(match_key_data.item_data));

      // if(trade_result){
      //   // trade.status = true
      // }

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
