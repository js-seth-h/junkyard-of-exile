<template>
  <div id="app">
<!--    <div class="header" @scroll="header_action" >-->

    <div class="header" :class="show_header === false?'off' : ''">
      header
      <button @click="show_gnb = !show_gnb" >gnb</button>
      //
      <button @click="seq_order = !seq_order">seq_order = {{seq_order}}</button>
    </div>


    <div class="content_wrapper">


      <div class="lnb" class="off" :class="show_gnb === false?'off' : ''">
        <Navigation :list_data="list_data" @emited_id="on_selected_id"></Navigation>
      </div>
      <!-- lnb end -->

      <div class="contents" style="color: #fff">
        <Item v-if="Object.keys(selected_data).length > 0 && list_data.length > 0" :item_data="selected_data.item_data"></Item>
        <div v-else> item is not exist</div>

        <Item_result v-if="Object.keys(selected_data).length > 0 && list_data.length > 0" :item_result="selected_data.item_data"></Item_result>
        <div v-else> empty result</div>
      </div>
      <!-- end contents -->

    </div>
    <!-- end contest_wrapper -->


    <transition name="search_trade_full">
      <div class="search_trade">
        trade
        <button class="search_trade_btn" @click="search_trade_full = !search_trade_full"> + </button>
      </div>
    </transition>

    <transition name="search_trade_full">
    <div class="search_trade" v-show="search_trade_full">
      trade
      <button class="search_trade_btn" @click="search_trade_full = !search_trade_full"> + </button>
      <transition name="search_trade_full">
        <div class="search_trade_full"
             v-show="search_trade_full">
          detail contents<br />
          detail contents<br />
          detail contents<br />
          detail contents<br />
          detail contents<br />
          detail contents<br />
          detail contents<br />
        </div>
      </transition>
    </div>
    </transition>
    <!-- end search_trade -->


  </div>
</template>
<script>

  // import axios from "axios"

  // import list_data from "../settings/list_data";


  import Dialog from "./dialog.vue";
  import Item from "./components/item.vue";
  import Navigation from "./components/navigation.vue"
  import Item_result from "./components/item_result.vue"


  import '../assets/css/main.css';

  import * as R from 'ramda'

  export default {
    name: 'Main',
    components: {Dialog, Item, Item_result, Navigation},
    computed: {
      list_data(){
        console.log('----------------------this.$store.state.list_data', this.$store.state.list_data)
        return this.$store.state.list_data
      }
    },
    data(){
      return{
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
        // trade 영역 축소/확대
        search_trade_full: false,


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
        for(let data of this.list_data){
          if(id === data.id){
            console.log('!!!!!!!!!!!!!', data)
            this.selected_data = data
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
