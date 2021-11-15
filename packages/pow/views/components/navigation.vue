<template>
  <div id="navigation">
  <v-app>


<!--    <div v-for="(item, key) of list_data" :key="key">-->
<!--      <v-tooltip right>-->
<!--        <template v-slot:activator="{ on, attrs }">-->
<!--          <button @click="">하트</button>-->
<!--          <button-->
<!--              v-bind="attrs"-->
<!--              v-on="on"-->
<!--              class="nav_con"-->
<!--              @click="emit_id(item.id)">-->
<!--            {{item.item_data.header.lines[2]}} {{item.item_data.header.lines[3]}}-->
<!--          </button>-->
<!--        </template>-->
<!--        <Item v-if="Object.keys(item).length > 0" :item_data="item.item_data"></Item>-->
<!--      </v-tooltip>-->
<!--    </div>-->
<!-- 즐겨찾기 end -->

    <button @click="remove_all">remove all item</button>
    <div v-for="(item, key) of list_data" :key="key">
      <v-tooltip right>
        <template v-slot:activator="{ on, attrs }">
          <button @click="bookmark(item.id, item.bookmark)">
            //{{item.bookmark}}//
          </button>
          <button
              v-bind="attrs"
              v-on="on"
              class="nav_con"
              @click="emit_id(item.id)">
            {{item.item_data.header.lines[2]}} {{item.item_data.header.lines[3]}}
          </button>
        </template>
        <Item v-if="Object.keys(item).length > 0" :item_data="item.item_data"></Item>
      </v-tooltip>
    </div>

  </v-app>
  </div>
</template>

<script>

  import Item from "./item";
  import Dialog from "../dialog";
  import Item_result from "./item_result";
  import STORE from "../../store";
  export default {
    name: "navigation",
    props:{
      list_data: Array
    },
    components: {Item},
    methods: {
      emit_id(id){
        console.log('111111111111111111111111111', id)
        this.$emit("emited_id", id)
      },
      remove_all(){
        let data = this.$store.state.list_data
        if(data.length > 0){
          this.$store.state.list_data = []
        }
      },
      //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      // 공용함수로 뽑아야함
      get_position_from_item_id( data_id){
        // state.list_data에서 id를 가진 데이터의 배열 번호를 추출하여 반환
        let list_data = this.$store.state.list_data
        let num = null
        for(let data in list_data){
          if(data_id === list_data[data].id){
            num = data

          }
        }
        return num
      },

      bookmark(id, bookmark){
       let num = this.get_position_from_item_id(id)
        bookmark = !bookmark
        this.$store.state.list_data[num].bookmark = bookmark
        console.log('1111111111bookmark', bookmark)
      }
    }
  }
</script>

<style scoped>

</style>
