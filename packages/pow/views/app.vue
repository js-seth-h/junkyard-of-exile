<template>
  <div id="app">
    <v-app id="inspire">
      <v-app id="inspire">
        <!-- gnb area start -->
        <v-navigation-drawer
          v-model="drawer"
          app
          clipped
        >
          <v-list dense>

            <div class="area_wrap">
              <button @click="show_textarea=!show_textarea">show_textarea</button>
              <div v-if="show_textarea === true">
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


            <v-list-item link v-for=" (list, key) in list_data" @click="change_show_data(key)">

              {{key}}
              <v-list-item-action>
                <v-icon>mdi-view-dashboard</v-icon>
              </v-list-item-action>
              <v-list-item-content>
                <v-list-item-title>
                  {{list.parsed_items.group[2]}}
                  {{list.parsed_items.group[3]}}
                </v-list-item-title>
              </v-list-item-content>
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

          <v-btn @click="dialog_event"> dialog btn </v-btn>
          <v-toolbar-title>Application</v-toolbar-title>
        </v-app-bar>
        <!-- header area end -->
        <!-- contents area start -->
        <v-main>
          <v-container
            fluid
          >
            <div class="detail">
              <div>

<!--                test: {{this.$store.state}} <br />-->
<!--                this_state : {{this_state}} <br />-->
<!--                list_data : {{list_data}} <br />-->
<!--                show_data : {{show_data}} <br />-->
                <v-btn >detail</v-btn>

                <div v-for="(choice_data, inx) of show_data.parsed_items">
                  <div v-if="inx === 'group'" class="title wrap">

                    <div v-for="(data, data_inx) of choice_data">
                      <p v-if="data_inx === 2"> {{data}} </p>
                      <p v-if="data_inx === 3"> {{data}} </p>
                    </div>
                  </div>
                  <div class="content">
                    {{inx}}
                    <div v-if="inx === 'requirements'" class="show_requirements">
                      <div v-for="(data, data_inx) of choice_data">
                        <span v-if="data_inx === 0" class="contents_subtitle">
                          {{data[0]}}
                        </span>
                        <span v-else>
                          {{data[0]}} {{data[1]}}
                        </span>
                      </div>
                      <span class="separator"></span>
                    </div>

                    <div v-else>
                      <div v-for="(data, data_inx) of choice_data">
                        <div v-if='typeof data[1] === "undefined"'>
                          {{data[0]}}
                        </div>
                        <div v-else>
                          {{data[0]}}: {{data[1]}}
                        </div>
                      </div>
                      <span class="separator"></span>
                    </div>


                  </div>
                </div>
              </div>
            </div>

            <div>
              <v-btn @click="parsing_text(show_data)">detail</v-btn>
            </div>
            <div>
              contents
            </div>
            <Dialog></Dialog>

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
      //
      // item_group(){
      //
      //   if(this.show_data[0] !== undefined){
      //
      //     let group = this.show_data[0][0]
      //     if(group !== undefined ){
      //       group = group.split(':')
      //     }else{
      //       group = ''
      //     }
      //     return group[1]
      //
      //   }
      // },
      // item_name(){
      //   if(this.show_data[0] !== undefined){
      //     return this.show_data[0][2]
      //   }
      // },
      // item_type(){
      //   if(this.show_data[0] !== undefined) {
      //     return this.show_data[0][3]
      //   }
      // },
      // item_value() {
      //   // this.show_data.shift()
      //
      //   if (this.show_data[0] !== undefined) {
      //
      //     let copied_show_data = this.show_data
      //     copied_show_data = copied_show_data.splice(1, this.show_data.length)
      //     return copied_show_data
      //   }
      // }
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

      dialog_event(){
        console.log('dialog')

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
      // parsing_text(text){
      // //  입력 후 가져온 텍스트의 모양을 변경한다.
      //
      //   console.log('text', text)
      //
      //   if(text.length ){
      //     console.log('-------is empty ----')
      //
      //   }else{
      //     console.log("is not empty")
      //   }
      // //  text = this.show_data
      //
      //   // console.log('text' , text)
      //
      //   // console.log('this is R', R)
      //
      //   var blocks = R.map(R.trim,R.split( '--------' ,  text ))
      //   blocks = R.map( R.split('\n'), blocks)
      //
      //   console.log(blocks)
      //
      //   this.show_data = blocks
      //
      //
      // },
      get_itemtext(){

        //get_itemtext = 버튼
        // writed_item 입력된 값

        // 텍스트 입력 후 버튼 클릭 시 값을 가져옴



        //입력된 값을 list_data arr에 push
        this.list_data.push(this.writed_item)

        // this.parsing_text(this.list_data[0])



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
  body{
    font-size: 14px;
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

</style>
