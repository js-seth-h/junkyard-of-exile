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

            <v-list-item link>
              <v-list-item-action>
                <v-icon>mdi-view-dashboard</v-icon>
              </v-list-item-action>
              <v-list-item-content>
                <v-list-item-title>Dashboard</v-list-item-title>
              </v-list-item-content>
            </v-list-item>
<!--            <v-list-item link>-->
<!--              <v-list-item-action>-->
<!--                <v-icon>mdi-cog</v-icon>-->
<!--              </v-list-item-action>-->
<!--              <v-list-item-content>-->
<!--                <v-list-item-title>Settings</v-list-item-title>-->
<!--              </v-list-item-content>-->
<!--            </v-list-item>-->
          </v-list>
        </v-navigation-drawer>

        <v-app-bar
          app
          clipped-left
        >
          <v-app-bar-nav-icon @click.stop="drawer = !drawer"></v-app-bar-nav-icon>
          <v-toolbar-title>Application</v-toolbar-title>
        </v-app-bar>

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
              <v-btn>detail</v-btn>
            </div>
          </v-container>
        </v-main>


<!--        <v-main>-->
<!--          <v-container-->
<!--            class="fill-height"-->
<!--            fluid-->
<!--          >-->
<!--            <v-row-->
<!--              align="center"-->
<!--              justify="center"-->
<!--            >-->
<!--              <v-col class="shrink">-->
<!--                <v-tooltip right>-->
<!--                  <template v-slot:activator="{ on }">-->
<!--                    <v-btn-->
<!--                      icon-->
<!--                      large-->
<!--                      target="_blank"-->
<!--                      v-on="on"-->
<!--                    >-->
<!--                      <v-icon large>mdi-code-tags</v-icon>-->
<!--                    </v-btn>-->
<!--                  </template>-->
<!--                  <span>Source</span>-->
<!--                </v-tooltip>-->
<!--              </v-col>-->
<!--            </v-row>-->
<!--          </v-container>-->
<!--        </v-main>-->

        <v-footer app>
          <span>&copy; {{ new Date().getFullYear() }}</span>
        </v-footer>
      </v-app>
    </v-app>
  </div>
</template>
<script>

  import axios from "axios"
  export default {
    name: 'App',
    data(){
      return{
        // drawer: null,
        //gnb 노출 셋팅
        drawer: null,

        // textarea 보여주기 세팅
        show_textarea : true,

        // textarea 입력된 값
        // writed_item: '아이템 종류: 한손 철퇴\n' +
        //   '아이템 희귀도: 희귀\n' +
        //   '침울한 일격\n' +
        //   '악몽의 철퇴\n' +
        //   '--------\n' +
        //   '한손 철퇴\n' +
        //   '물리 피해: 39-83 (augmented)\n' +
        //   '치명타 확률: 6.35% (augmented)\n' +
        //   '초당 공격 횟수: 1.40\n' +
        //   '무기 범위: 11\n' +
        //   '--------\n' +
        //   '요구사항:\n' +
        //   '레벨: 68\n' +
        //   '힘: 212\n' +
        //   '--------\n' +
        //   '홈: G-R-R \n' +
        //   '--------\n' +
        //   '아이템 레벨: 71\n' +
        //   '--------\n' +
        //   '적 기절 한계치 10% 감소 (implicit)\n' +
        //   '--------\n' +
        //   '물리 피해 1~3 추가\n' +
        //   '치명타 확률 27% 증가\n' +
        //   '화염 저항 +21%\n' +
        //   '물리 공격 피해의 0.35%를 마나로 흡수\n' +
        //   '권능 충전 하나당 피해 5% 증가',


        writed_item:'',

        //파싱된 아이템들
        list_data: {}

      }
    },
    methods: {
      get_itemtext(){


        console.log(this.writed_item)
        let testdata1 = this.writed_item.split('--------')
        console.log('testdata1',testdata1)


        let testdata2 = this.writed_item.split('\n')
        console.log('testdata2',testdata2)
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
