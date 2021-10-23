<template>
  <div id="app">
    <v-app id="inspire">
      <v-app id="inspire">
        <!-- gnb area start -->
        <v-navigation-drawer
          v-model="drawer"
          app
          clipped
          width="27%"
        >
          <v-list dense>

            <div class="area_wrap">
              <button @click="show_textarea=!show_textarea">+</button>
              <div v-if="show_textarea === false">
                <v-textarea
                  outlined
                  label="Outlined textarea"
                  value=""
                  v-model="writed_item"
                >
                </v-textarea>
                <button @click="get_itemtext">submit</button>
              </div>
            </div>

            <button @click="get_data"> SEND </button>

            <br />

            <Dialog></Dialog>




            <v-list-item link v-for=" (list, key) in list_data" @click="change_show_data(key)">

              {{key}}
              <v-list-item-action>
                <v-icon>mdi-view-dashboard</v-icon>
              </v-list-item-action>
              <v-list-item-content>
                <v-list-item-title>
                  {{list.parsed_items.group[2][0]}}
                  {{list.parsed_items.group[3][0]}}
                </v-list-item-title>
              </v-list-item-content>
              <i class="fas fa-check"></i>
            </v-list-item>

          </v-list>
        </v-navigation-drawer>
        <!-- gnb area start -->


        <!-- header area start -->
        <v-app-bar
          app
          clipped-left
        >
          <v-app-bar-nav-icon @click.stop="drawer = !drawer"> list </v-app-bar-nav-icon>

          <v-btn> dialog btn </v-btn>
          <v-toolbar-title>Application</v-toolbar-title>
        </v-app-bar>
        <!-- header area end -->
        <!-- contents area start -->
        <v-main>
          <v-container fluid>
            <div class="detail">
              <div>

                <div v-for="(selected_data, inx) of show_data.parsed_items" class="selected_data_area">

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
            </div>

            <div>
              ----contents----
            </div>

          </v-container>
        </v-main>
        <!-- contents area end -->

        <!--        <Dialog></Dialog>-->

        <v-footer app>
          <span>&copy; {{ new Date().getFullYear() }}</span>
        </v-footer>
      </v-app>
    </v-app>
  </div>
</template>
<script>

  // import axios from "axios"

  // import list_data from "../settings/list_data";

  import Dialog from "./dialog.vue";


  import * as R from 'ramda'

  export default {
    name: 'App',
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

      }
    },

    mounted() {

      // list_data:{
      //   return this.$store.state.list_data
      //   // }
      // }
    },
    methods: {
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


<style lang="scss">
  .area_wrap{
    margin: 10px;
  }
  .detail{
    /*width: 400px;*/
  }
  .detail .title{

    height: 53px;
    color:#ffff77;
    background:
      url(https://web.poecdn.com/image/item/popup/header-double-rare-left.png?1621837936832) top left no-repeat,
      url(https://web.poecdn.com/image/item/popup/header-double-rare-right.png?1621837936832) top right no-repeat,
      url(https://web.poecdn.com/image/item/popup/header-double-rare-middle.png?1621837936832) top center repeat-x;
  }

  .detail .title p{
    text-align: center;
    /*padding: 10px;*/
    font-size: 19px;
    margin: unset;
    line-height: 1.35em;
    letter-spacing: -0.025;
  }
  .detail .content{
    background-color: rgba(0, 0, 0, 0.8);;
    text-align: center;
  }

  .separator{
    background: url(https://web.poecdn.com/image/item/popup/seperator-rare.png?1629690613755) center center no-repeat;
    /*background: url(https://web.poecdn.com/image/item/popup/seperator-rare.png?1624341092737) top center no-repeat;*/
    height: 8px;
    width: 100%;
    display: flex;
  }

  .show_requirements{
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
  }
  .show_requirements:first-child{
    padding-right: 10px;
  }
  /*:last-child .content .separator*/
  .selected_data_area:last-child .separator{
    display: none;
    background-color: red;
  }



</style>
