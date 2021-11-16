<template>
  <div id="navigation">
  <v-app>


    <div v-for="(item, key) of storage_data" :key="key">
      <v-tooltip right>
        <template v-slot:activator="{ on, attrs }">
          <button @click="add_bookmark(item.id, item.bookmark)">
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
<!-- 즐겨찾기 end -->
    <div>-----------------------------</div>

    <button @click="remove_all">remove all item</button>
    <div v-for="(item, key) of list_data" :key="key">
      <v-tooltip right>
        <template v-slot:activator="{ on, attrs }">
          <button @click="add_bookmark(item.id, item.bookmark)">
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
    computed: {
      storage_data(){
        console.log('----------------------JSON.parse(localStorage.getItem(\'storage_data\'))', JSON.parse(localStorage.getItem('storage_data')))
        return JSON.parse(localStorage.getItem('storage_data'))
      }
    },
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
      get_position_from_item_id(data_id){
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

      exist_id_from_storage(data_id){
        // state.list_data에서 id를 가진 데이터의 배열 번호를 추출하여 반환
        let storage_data = JSON.parse(localStorage.getItem('storage_data'))
        let num = null
        for(let data in storage_data){
          if(data_id === storage_data[data].id){
            num = data

          }
        }
        return num
      },
      remove_bookmark(){
        // exist_id_from_storage(num)
      },

      add_bookmark(id, bookmark){
       let num = this.get_position_from_item_id(id)
        bookmark = !bookmark

        let this_data = this.$store.state.list_data[num]
        this_data.bookmark = bookmark
        let storage_data = JSON.parse(localStorage.getItem('storage_data'))

        if(storage_data === null){
          localStorage.setItem('storage_data', JSON.stringify([this_data]))
        }else{
          // localStorage에 데이터가 있는경우
          let check_num = this.exist_id_from_storage(this_data.id)
          if(check_num !== null){
            // 키 중복
            console.log('키 중복')
          }else{
            // 키 미중복
            storage_data.push(this_data)
            localStorage.setItem('storage_data', JSON.stringify(storage_data))
          }
        }

      }
    }
  }
</script>

<style scoped>

</style>
