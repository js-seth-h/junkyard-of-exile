<template>
  <div id="app"  @scroll="header_action">
<!--    <div class="header" @scroll="header_action" >-->


    <div class="header" :class="show_header === false?'off' : ''">
      header
      <button @click="show_gnb = !show_gnb" >gnb</button>
    </div>
    <div class="lnb" class="off" :class="show_gnb === false?'off' : ''">

      lnb
      <div  v-for="(data, key) of list_data" :key="key">
        <div>key: {{key}}</div>
        <div v-for="(con, key) of data" :key="key">
<!--          {{con.item_id}}-->
          <button @click="go_to_content(con.item_id)">{{con.parsed_items.group[2][0]}} {{con.parsed_items.group[3][0]}}</button>

        </div>
      </div>
    </div>
    <div class="contents">
      <div class="division" v-for="(data, key) of list_data" :key="key">
        <div style="color:#fff"><h1>{{key}}</h1></div>
        <div class="item" v-for="(con, key) of data" :key="key" :id="con.item_id">
          <div class="item_img">
            img
            {{con.img}}
            <img :src="con.img" alt="">
  <!--          <img src="https://web.poecdn.com/gen/image/WzI1LDE0LHsiZiI6IjJESXRlbXMvV2VhcG9ucy9PbmVIYW5kV2VhcG9ucy9TY2VwdGVycy9zY2VwdGVyMiIsInciOjIsImgiOjMsInNjYWxlIjoxfV0/e3e72321e0/scepter2.png" alt="">-->
          </div>
  <!--        <div style="background-color: white">{{list_data}}</div>-->
          <div class="item_detail" >

            <div v-for="(selected_data, inx) of con.parsed_items" class="selected_data_area">

              <div v-if="inx === 'group'" class="title wrap">
                <div v-for="(data, data_inx) of selected_data">
                  <p v-if="data_inx === 2 || data_inx === 3"> {{data[0]}} </p>
                </div>
              </div>

              <div class="content">
                <div v-for="(data, data_inx) of selected_data"  :class="inx+'_subtitle'">
                  <div v-if='inx !== "group" '>
                    <div v-if='typeof data[1] === "undefined"' class="single">
                      {{data[0]}}
                    </div>
                    <div v-else class="multiple">
                      {{data[0]}}: {{data[1]}}
                    </div>
                  </div>
                </div>

                <span v-if='inx !== "group"  && selected_data !== undefined '
                      :class="inx+'_separator'" class="separator">
                  </span>


              </div>
            </div>
          </div>

          <div class="item_result">
            result
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>

  // import axios from "axios"

  // import list_data from "../settings/list_data";


  import Dialog from "./dialog.vue";

  import '../assets/css/main.css';

  import * as R from 'ramda'

  export default {
    name: 'Main',
    components: {Dialog},
    computed: {
      this_state(){
        return this.$store.state
      },
      list_data(){

        return this.$store.state.list_data
      },
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

        //파싱된 아이템들
        // list_data: []
        // list_data: list_data,
        // show_data: [[],[],[],[]],
        show_data: {},

        // 스크롤의 마지막 위치
        last_scroll_postion: 0,
        // header on off
        show_header: true,

        //gnb on off
        show_gnb: false,


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
      go_to_content(target){

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
        }else{
        //  scroll down
        //   console.log('scroll down', st);
          value = false
          this.show_gnb = false
        }

        if(value !== this.show_header){
          this.show_header = value
        }
        this.last_scroll_postion = st <= 0 ? 0 : st; // For Mobile or negative scrolling


      },

      header_action(e){

      },

      sendMessage(message) {
        console.log(this.connection);
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

      change_show_data(key){
        //리스트 클릭 시 화면에 뿌려지는 값


        // console.log('store.state.count', this.$store.state.data)

        console.log('this.list_data[key]', this.list_data[key].parsed_items.group[2])
        this.show_data = this.list_data[key]

        console.log('this.list_data[key].parsed_items', this.list_data[key].parsed_items)
        console.log('this.show_data', this.show_data)





        // console.log(this.show_data)
      },
      get_itemtext(){

        //입력된 값을 list_data arr에 push
        this.list_data.push(this.writed_item)




      },
      test(){
        alert(1)
      }

    },
    watch: {

      this_state(newData, oldData){
        console.log('new, old', newData, oldData)
      }
      // this_state:{
      //   deep: true,
      //   handler(val){
      //
      //     this.this_state = val
      //     console.log('this is val ', val)
      //
      //   }
      // },

    }


  }
</script>

<style>
</style>
