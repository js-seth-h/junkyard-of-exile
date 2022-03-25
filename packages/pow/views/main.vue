<template>
  <div id="app">
    <!--    <div class="header" @scroll="header_action" >-->

    <div class="header" :class="show_header === false?'off' : ''">
      <div class="left">
        <div class="header_title">Junkyard of Exile</div>
        <button class="nav_btn" :class="show_gnb === false?'off' : 'on'" @click="show_gnb = !show_gnb" >gnb</button>
      </div>

      <div class="right">
        <button @click="seq_order = !seq_order">seq_order = {{seq_order}}</button>
        <Dialog_trade_controller></Dialog_trade_controller>
        <Dialog_trade_controller2></Dialog_trade_controller2>
        <button @click="trade_ctl = !trade_ctl">Trade_controller</button>
      </div>


    </div>


    <div class="wrapper">


      <div id="navigation" :class="show_gnb === false?'off' : 'on'">
        <Navigation :list_data="list_data" @emited_id="on_selected_id"></Navigation>
      </div>
      <!-- lnb end -->

      <div class="contents_wrap">
        <div class="contents" style="color: #fff">
          <div v-if="trade_ctl === false">
            <Item v-if="Object.keys(selected_data).length > 0 " :item_data="selected_data.item_data"></Item>
            <div v-else> item is not exist</div>

            <Item_result v-if="Object.keys(selected_data).length > 0 " :item_result="selected_data.item_data"></Item_result>
            <div v-else> empty result</div>
          </div>
          <div v-else>
            <Trade_controller id="trade_controller"></Trade_controller>
          </div>
        </div>

        <!-- end contents -->

         start trade
        <div class="trade" id="trade" >
          <Trade :trade_data="trade_data" ></Trade>
        </div>
         end trade

      </div>
    </div>
    <!-- end contest_wrapper -->



  </div>
</template>
<script>

// import axios from "axios"

// import list_data from "../settings/list_data";


import Dialog from "./dialog.vue";
import Dialog_trade_controller2 from "./components/dialog/trade_controller2"
import Dialog_trade_controller from "./components/dialog/trade_controller"
import Item from "./components/item.vue";
import Navigation from "./components/navigation.vue"
import Item_result from "./components/item_result.vue"
import Trade from "./components/trade.vue"



import '../assets/css/main.css';
import '../assets/css/navigation.css';
import '../assets/css/trade.css';



import * as R from 'ramda'

export default {
  name: 'Main',
  components: {Dialog, Dialog_trade_controller, Dialog_trade_controller2, Item, Item_result, Navigation, Trade},
  computed: {
    list_data(){
      console.log('----------------------this.$store.state.list_data', this.$store.state.list_data)
      return this.$store.state.list_data
    },
    trade_data(){
      // console.log('----------------------this.$store.state.trade_data', this.$store.state.trade_data)
      return this.$store.state.trade_data

      // return this.$store.state.list_data
    },

    storage_data(){
      console.log('----------------------JSON.parse(localStorage.getItem(\'storage_data\'))', JSON.parse(localStorage.getItem('storage_data')))
      return JSON.parse(localStorage.getItem('storage_data'))
    }
  },
  data(){
    return{

      //검색 필터 컨트롤 화면
      trade_ctl: false,

      // drawer: null,
      //gnb 노출 셋팅
      // drawer: null,
      drawer: null,
      // textarea 보여주기 세팅
      show_textarea : true,



      writed_item:'',

      selected_data: {},

      // 스크롤의 마지막 위치
      last_scroll_postion: 0,
      // header on off
      show_header: true,

      //gnb on off
      show_gnb: false,

      // 출력 옵션 컨트롤 - 미구현
      seq_order: true,


    }
  },

  mounted() {

    // list_data:{
    //   return this.$store.state.list_data
    //   // }
    // },
    window.addEventListener("scroll", this.onScroll, false)
  },
  beforeDestroy() {
    window.removeEventListener("scroll", this.onScroll, false)
  },
  methods: {
    on_selected_id(id){
      // emit에서 받은 데이터
      console.log('id------------', id)
      let stat = false
      for(let data of this.list_data){
        if(id === data.id){
          console.log('!!!!!!!!!!!!!', data)
          this.selected_data = data
          stat = true
        }
      }
      if(stat === false){
        for(let data of this.storage_data){
          if(id === data.id){
            console.log('!!!!!!!!!!!!22222!', data)
            this.selected_data = data
          }
        }
      }
    },

    onScroll(e) {
      // let st = (window.pageYOffset || document.documentElement.scrollTop);
      let st = window.top.scrollY
      // console.log('event', e )
      let value = true
      if(this.last_scroll_postion > st ){
        //  scroll up
        //   console.log('scroll up', st);
        value = true
      }
      //up 스크롤시 lnb display none
      // else{
      // //  scroll down
      // //   console.log('scroll down', st);
      //   value = false
      //   this.show_gnb = false
      // }

      if(value !== this.show_header){
        this.show_header = value
      }
      this.last_scroll_postion = st <= 0 ? 0 : st; // For Mobile or negative scrolling


    },


    get_data(){
      let data = false
      if(data){
        console.log('call data pass -- data exist')
      }else{
        console.log('call data block -- data not exist -- call wall')
        this.call_dialog_event()
      }
    },

    call_dialog_event(){
      // 다이얼로그 이벤트 call
      alert('call dialog')
      return true

    },


  },
  watch: {

  }


}
</script>

<style>
</style>
