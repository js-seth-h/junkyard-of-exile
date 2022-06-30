import Vue from 'vue'
import Vuex from 'vuex'
// import router from '../router'
// import axios from "axios"

import R from 'ramda'
import RA from 'ramda-adjunct'


import bridge from 'exterra/bridge.coffee'

import trader from 'exterra/trader.coffee'
import PTF from 'ptf4/index.coffee'
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
  //패킷으로 보낼때 아이디 추가
  obj.be_msg.id = obj.id
  bridge.emit('eval-ptf4', obj.be_msg );

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
  obj.be_msg = PTF.forBackend(parsed_data)

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
    trade_data: [
      {
        id: 'test1',
        name:'용의 파괴자 카루이 절단기 1',
        process:'done',
        status: false,
      },
      {
        id: 'test2',
        name:'태풍 꼬챙이 원석 검 2',
        process:'ing',
        status: false,
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

    trade_data_controller:{
      item_list: [
        {item_name:'슬픔의 갈망 에조미어 도끼 1'},
        {item_name:'슬픔의 갈망 에조미어 도끼 2'},
      ],
      all_blocks: [
        {
          block_name:'내 블록 리스트',
          filters:[
            {
              filter_name:'블록1-0',
              status: false,
              exp: "F>3.3 / P>2.3 / A and D > 1",

            },
            {
              filter_name:'블록1-1',
              status: false,
              exp: "F>3.4 / P>2.3 / D and D > 2",
            },
          ]
        },
        {
          block_name:'블록_wrap1',
          filters:[
            {
              filter_name:'블록2-1',
              status: false,
              exp: "F>3.5 / P>2.3 / B and D > 2",
            },
            {
              filter_name:'블록2-2',
              status: false,
              exp: "F>3.6 / P>2.3 / A and D > 2",
            },
          ]
        },
        {
          block_name:'블록_wrap2',
          filters:[
            {
              filter_name:'블록3-1',
              status: false,
              exp: "F>3.7 / P>2.3 / A+ and D > 2",
            },
            {
              filter_name:'블록3-2',
              status: false,
              exp: "F>3.8 / P>2.3 / A+ and D > 2",
            },
          ]
        },

      ],

      used_filters: [
        // {
        //   filter_name:'블록1',
        //   status: false,
        //   exp: "F>3.9 / P>2.3 / A+ and D > 2",
        // },
        // {
        //   filter_name:'블록2',
        //   status: false,
        //   exp: "F>3.0 / P>2.3 / A+ and D > 3",
        // },
      ]
    },

    // trade_data_controller: [
    //   {
    //     name:'용의 파괴자 카루이 절단기 1',
    //     status: false,
    //   },
    //   {
    //     name:'태풍 꼬챙이 원석 검 2',
    //     status: false,
    //   },
    //   {
    //     name:'마음의 바늘 아로새긴 마법봉 3',
    //     status: false,
    //   },
    //   {
    //     name:'강풍의 꼬임 성채 활 4',
    //     status: false,
    //   },
    //   {
    //     name:'슬픔의 갈망 에조미어 도끼 5',
    //     status: false,
    //   },
    //   {
    //     name:'슬픔의 갈망 에조미어 도끼 6',
    //     status: false,
    //   },
    //   {
    //     name:'슬픔의 갈망 에조미어 도끼 7',
    //     status: false,
    //   }
    //
    // ],





  },
  getters: {
    list_data: (state) => {
      return state.list_data;
    },
    trade_data: (state) => {
      return state.trade_data;
    },
    trade_data_controller: (state) => {
      return state.trade_data_controller;
    },
    used_filters: () => {
      return JSON.parse(localStorage.getItem('used_filters'))
    },
  },

  mutations: {

    add_item (state, payload) {
      state.list_data.push(payload)
    },
    replace_trade_used_filter(state, payload) {
      state.trade_data_controller.used_filters = payload
    },
    add_trade_used_filter(state, payload) {
      state.trade_data_controller.used_filters.push(payload)
    },



    replace_storage_filters(state, payload) {
      localStorage.removeItem('used_filters');
      // let used_filters = state.used_filters.push(payload)

      localStorage.setItem('used_filters', JSON.stringify(payload));
    },
    add_storage_filters(state, payload) {
      let used_filters = localStorage.getItem('used_filters')

      var data = ''

      if(used_filters === null || used_filters === 'undefined'){

        localStorage.removeItem('used_filters');

        data = payload
        // localStorage.setItem('used_filters', JSON.stringify(payload));
      }else{
        var storage_filter = JSON.parse(used_filters);

        storage_filter.push(payload)
        // localStorage.setItem('used_filters', JSON.stringify(storage_filter));
        data = storage_filter
      }

      localStorage.removeItem('used_filters');

      localStorage.setItem('used_filters', JSON.stringify(data));

      // localStorage.setItem('used_filters', JSON.parse(JSON.stringify(data)));


    },



  },
  actions: {
    replace_trade_used_filter(context, payload) {
      context.commit('replace_storage_filters', payload)
      context.commit('replace_trade_used_filter', payload)
    },

    add_trade_used_filter(context, payload) {
      context.commit('add_storage_filters', payload)
      context.commit('add_trade_used_filter', payload)
    },

    async update_item_by_server(context, evaluate_result){
      let data_id = evaluate_result.id
      let list_data = context.state.list_data
      let trade_data = context.state.trade_data

      // 해당 id를 가지고있는 데이터의 배열 번호 추출
      let result = get_position_from_item_id(data_id)

      let match_key_data = result


      // 서버에서 반환된 평가 데이터(Rating)을 아이템 데이터에 반영
      console.log('applyEval', match_key_data, evaluate_result)
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


    },



  }
})

export default STORE
