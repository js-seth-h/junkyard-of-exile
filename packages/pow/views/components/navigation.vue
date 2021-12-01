<template>
  <div id="navigation">
  <v-app>


    <div v-if="storage_data !== undefined" v-for="(storage_item, storage_key) of storage_data" :key="'storage'+storage_key">
      <v-tooltip right>
        <template v-slot:activator="{ on, attrs }">
          <button @click="remove_bookmark(storage_item)">
            remove
          </button>
          {{storage_data.rating}}
          <button
              v-bind="attrs"
              v-on="on"
              class="nav_con"
              @click="emit_id(storage_item.id)">
            {{storage_item.item_data.header.lines[2]}} {{storage_item.item_data.header.lines[3]}}
          </button>
        </template>
        <Item v-if="Object.keys(storage_item).length > 0" :item_data="storage_item.item_data"></Item>
      </v-tooltip>
    </div>
<!-- 즐겨찾기 end -->
    <div>-----------------------------</div>

    <button @click="remove_all">remove all item</button>
    <div v-if="list_data !== undefined"  v-for="(item, key) of list_data" :key="key">
      <v-tooltip right>
        <template v-slot:activator="{ on, attrs }">
          <button @click="add_bookmark(item)">
            add
          </button>
          <p v-if="item.rating != 'undefined'">
<!--            **{{item.rating.includes('F')}}**-->
<!--            **{{item.rating.find(element => element = 'F')}}**-->
            {{item.rating}}
          </p>
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
      // storage_data(){
      //   return JSON.parse(localStorage.getItem('storage_data'))
      // }

      // storage_auto_trade_option(){
      //   console.log('JSON.parse(localStorage.getItem(\'ranking\'))', JSON.parse(localStorage.getItem('auto_trade_option')))
      //   if(JSON.parse(localStorage.getItem('auto_trade_option')) === null){
      //     localStorage.setItem('auto_trade_option', JSON.stringify(true))
      //   }
      //   return this.auto_trade_option = JSON.parse(localStorage.getItem('auto_trade_option'))
      // }

    },
    data() {
      return {
        storage_data: JSON.parse(localStorage.getItem('storage_data')),

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
      //!!!!!!!!!!!!!!!!!!!!!!!!!!
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
      remove_bookmark(this_data){
        let storage_data = JSON.parse(localStorage.getItem('storage_data'))
        if(storage_data !== null){
          // localStorage에 데이터가 있는경우
          let check_num = this.exist_id_from_storage(this_data.id)
          if(check_num !== null){
            // 데이터 빼는 코드 필요
            console.log('storage_data before',storage_data)

            storage_data.splice(check_num,1)
            console.log('storage_data after',storage_data)

            // js,filter
            // storage_data.push(this_data)
            localStorage.setItem('storage_data', JSON.stringify(storage_data))
            this.storage_data = storage_data
          }else{
            // 이미 처리되었거나 없음

          }
        }

      },

      get_position_from_item_id( data_id){
        // state.list_data에서 id를 가진 데이터의 배열 번호를 추출하여 반환
        let list_data = STORE.state.list_data
        let num = null
        for(let data in list_data){
          if(data_id === list_data[data].id){
            num = data

          }
        }
        return num
      },

      add_bookmark(this_data){
        let storage_data = JSON.parse(localStorage.getItem('storage_data'))

        let num = this.get_position_from_item_id(this_data.id)
        // rating이 없는데이터 필터링
        if(this_data.rating !== undefined){

          if(storage_data === null){
            localStorage.setItem('storage_data', JSON.stringify([this_data]))
            this.storage_data = storage_data

            this.$store.state.list_data.splice(num,1)
          }else{
            // localStorage에 데이터가 있는경우
            let check_num = this.exist_id_from_storage(this_data.id)
            if(check_num !== null){
              // 키 중복
              console.log('키 중복')
            }else{
              // 키 미중복
              storage_data.push(this_data)

              this.$store.state.list_data.splice(num,1)
              localStorage.setItem('storage_data', JSON.stringify(storage_data))
              this.storage_data = storage_data
            }
          }
        }else{
          console.log('등급 산정이 끝나지 않은 데이터임')
        }
      }

    }
  }
</script>

<style scoped>

</style>
