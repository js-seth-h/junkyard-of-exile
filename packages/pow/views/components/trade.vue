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
      <button @click="trade_data_splice" style="background-color: yellow"> splice </button>
      <br />
      {{trade_data}}
      <br />
    dragged: {{dragged}}
      <div class="trade_content" v-show="trade_content" style="margin-left: 50px">

        <div v-for="(item, key) of trade_data" :key="key"
        >
          {{item.status}}
          <button draggable="true"
                  v-on:dragstart="dragstart"
                  v-on:dragover="dragover"
                  v-on:dragleave="onDragLeave"
                  v-on:drop="onDrop"
                  v-on:draged="dragend"
                  v-on:dragenter="dragenter"
                  v-bind:id="item.id"
                  style="background-color: #fff; margin-bottom: 40px;">
            {{item.name}}
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
      trade_data: Array,
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
        trade_content : true,
        auto_trade_option: true,
        dragged:null,

        drag_status_ing: false,
      }
    },
    methods: {
      trade_data_splice(){
        // 중간에 삽입
        let data = {
          id: 'test11',
          name:'마음의 바늘 아로새긴 마법봉 11',
          status: false,
        }
        this.trade_data.splice(2, 0, data)
      },
      onDragLeave(e){
        console.log('onDragLeave', e)
        e.target.style.background = "white";
        e.target.style.opacity = 1;
      },
      dropHandler(e){
        // console.log('dropHandler', e)
      },
      dragstart(e){
        this.dragged = e.target;
        e.target.style.opacity = .5;
        console.log('dragstart', e)
      },
      dragend(e){
        e.target.style.opacity = 1;
      },
      dragover(e){
        console.log('dragHandler', e)
      },
      dragenter(e){

        e.target.style.background = "blue";
        // e.target.addClass = "item_over";
        console.log('ondragover', e)
      },
      onDrop(e){

        e.target.parentNode.removeChild( this.dragged );
        e.target.appendChild( this.dragged );
        console.log('onDrop', e)
        alert(1)
      }
    }

  }
</script>

<style scoped>

</style>
