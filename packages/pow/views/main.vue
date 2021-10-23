<template>
  <div id="app"  @scroll="header_action">
<!--    <div class="header" @scroll="header_action" >-->
      <div class="header" :class="header_active === false?'off' : ''">
      header

    </div>
    <div class="lnb">
      lnb
    </div>
    <div class="contents">
      content
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


        scroll_action: 0,
        header_active: true,

      }
    },

    mounted() {

      // list_data:{
      //   return this.$store.state.list_data
      //   // }
      // }
    },
    mounted() {
      window.addEventListener("scroll", this.onScroll)
    },
    beforeDestroy() {
      window.removeEventListener("scroll", this.onScroll)
    },
    methods: {
      onScroll(e) {
        let windowTop = window.top.scrollY /* or: e.target.documentElement.scrollTop */
        if(this.scroll_action > windowTop ){
        //  scroll up
          console.log('scroll up', windowTop);
          this.header_active = true
        }else{
        //  scroll down
          console.log('scroll down', windowTop);
          this.header_active = false
        }

        // this.windowTop = window.top.scrollY /* or: e.target.documentElement.scrollTop */
        // console.log('scroll event action ',window.top.scrollY)


        this.scroll_action = windowTop

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
