<template>
  <div id="app">
    <v-app id="inspire">
      <v-app id="inspire">
        <v-navigation-drawer
          v-model="drawer"
          app
          clipped
        >
          <v-list dense>
            <v-list-item>

              <button @click="show_textarea=!show_textarea">show_textarea</button>
            </v-list-item>
            <v-list-item v-if="show_textarea === true">
              <v-textarea
                outlined
                label="Outlined textarea"
                value=""
                v-model="writed_item"
              >
              </v-textarea>
              <button @click="get_itemtext">submit</button>
            </v-list-item>


            <v-list-item link v-for=" (list, key) in list_data" @click="chagne_show_data(key)">
              <v-list-item-action>
                <v-icon>mdi-view-dashboard</v-icon>
              </v-list-item-action>
              <v-list-item-content>
                <v-list-item-title>{{key}},{{list}}</v-list-item-title>
              </v-list-item-content>
            </v-list-item>

          </v-list>
        </v-navigation-drawer>

        <v-app-bar
          app
          clipped-left
        >
          <v-app-bar-nav-icon @click.stop="drawer = !drawer"> list </v-app-bar-nav-icon>
          <v-toolbar-title>Application</v-toolbar-title>
        </v-app-bar>
        <!-- contents area start -->
        <v-main>
          <v-container
            fluid
          >
            <div class="detail">
              <v-btn>detail</v-btn>
              <div class="title wrap">
                <p>title1</p>
                <p>title2</p>
              </div>
              <div class="content">
                test
              </div>
            </div>

            <div>
              <v-btn @click="parsing_text()">detail</v-btn>
            </div>

            <p>this is show_data value</p>
            <div>
              {{show_data}}
            </div>
          </v-container>
        </v-main>
        <!-- contents area end -->


        <v-footer app>
          <span>&copy; {{ new Date().getFullYear() }}</span>
        </v-footer>
      </v-app>
    </v-app>
  </div>
</template>
<script>

  import axios from "axios"

  import list_data from "./list_data";
  export default {
    name: 'App',
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
        list_data: list_data,
        show_data: []

      }
    },
    methods: {

      chagne_show_data(key){
        //리스트 클릭 시 화면에 뿌려지는 값
        this.show_data = this.list_data[key]

        // console.log(this.show_data)
      },
      parsing_text(text){
      //  입력 후 가져온 텍스트의 모양을 변경한다.
      //  text = this.writed_item

        text = this.list_data[0]

        console.log('text' , text)

        blocks = R.map R.trim, R.split '--------', item_str
        blocks = R.map R.split('\n'), blocks


        let parts = this.writed_item.split('--------')
        // console.log('testdata1',parts)



        // this.list_data.push(parts)

        // Object.assign(this.list_data, this.writed_item)
        //
        // console.log(this.list_data)


        // let testdata2 = this.writed_item.split('\n')
        // console.log('testdata2',testdata2)


        this.show_data = text


      },
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

    }

  }
</script>


<style lang="scss">
  .detail{
    width: 400px;
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
  }

</style>
