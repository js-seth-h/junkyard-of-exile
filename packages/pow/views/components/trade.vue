<template>
  <div class="trade_wrap" id="trade_wrap" >

<!--    <v-app>-->

      <button class="trade_btn" @click="trade_content = !trade_content"> + </button>
      <div>
        {{auto_trade_option}}
        <v-switch
            v-model="auto_trade_option"
            label="auto ranking"
            color="red darken-3"
            hide-details
        ></v-switch>
      </div>

      <div class="trade_content" v-show="trade_content">

        <div v-for="(item, key) of list_data" :key="key">
          <button >
            {{item.item_data.header.lines[2]}} {{item.item_data.header.lines[3]}}
          </button>

        </div>
      </div>
<!--    </v-app>-->
  </div>
</template>

<script>
  export default {
    name: "trade",
    props:{
      list_data: Array,
    },
    computed: {
      storage_auto_trade_option(){
        console.log('JSON.parse(localStorage.getItem(\'ranking\'))', JSON.parse(localStorage.getItem('auto_trade_option')))
        if(JSON.parse(localStorage.getItem('auto_trade_option')) === null){
          localStorage.setItem('auto_trade_option', JSON.stringify(true))
        }
        return this.auto_trade_option = JSON.parse(localStorage.getItem('auto_trade_option'))
      }
    },

    data() {
      return {
        // 컨텐츠 영역 열고닫기 버튼 조작
        trade_content : true ,
        auto_trade_option: true,
      }
    }
  }
</script>

<style scoped>

</style>
