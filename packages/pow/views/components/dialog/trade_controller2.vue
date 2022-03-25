<template>
  <v-dialog
    v-model="dialog"
    fullscreen
    hide-overlay
    transition="dialog-bottom-transition"
  >
    <template v-slot:activator="{ on, attrs }">
      <v-btn
        color="primary"
        dark
        v-bind="attrs"
        v-on="on"
      >
        Open Dialog2
      </v-btn>
    </template>
    <v-card
        id="trade_controller">
      <v-toolbar
        dark
        color="primary"
      >
        <v-toolbar-title>Junkyard of Exile - 2</v-toolbar-title>
        <v-spacer></v-spacer>
        <v-toolbar-items>

          <v-btn
            @click="dialog = false"
          >
            dialog close
          </v-btn>
          <v-btn
            dark
            text
            @click="alert('prev')"
          >
            prev
          </v-btn>

          <v-btn
            dark
            text
            @click="alert('next')"
          >
            next
          </v-btn>

        </v-toolbar-items>
      </v-toolbar>
      <div class="wrapper">
        <div class="make_block wrap_area" v-show="show_make_block.show">
          <button @click="select_block_stat( false,null, null)"> block remove btn</button>
          <div v-if="show_make_block.key === null" class="new">
            <div>
              {{this.maked_block}}
              <label for="block_name">name</label>
              <input type="text" name="block_name" id="block_name" v-model="maked_block.name" style="border:1px solid #ddd; color: #fff;" >

              <div style="display: flex;">
                <label for="block_type_F">block_type_F</label>
                <input type="radio" name="block_type_F" v-model="maked_block.type" value="F" id="block_type_F">
                <label for="block_type_P">block_type_P</label>
                <input type="radio" name="block_type_P"  v-model="maked_block.type" value="P" id="block_type_P">
              </div>

              <div class="search_wrap">
                <div class="select_level_combobox">
                  <v-combobox
                      v-model="maked_block.stat"
                      :items="level"
                      label="Choose an item that includes level type."
                      multiple
                      chips

                  ></v-combobox>

<!--                  <v-combobox-->
<!--                      v-model="selected_level"-->
<!--                      :items="level"-->
<!--                      label="Choose an item that includes level type."-->
<!--                      multiple-->
<!--                      chips-->

<!--                  ></v-combobox>-->
                </div>
                <button class="search_btn">검색하기</button>
              </div>


              <div v-for="(val, key) in this.maked_block.stat">
                <label :for="val">{{val}}</label>
                <input style="border:1px solid #ddd;" type="text" :name="val" :id="val">
              </div>



            </div>
            show_make_block: {{show_make_block}}
            <br />
            <button class="btn" @click="save_block"> save </button>
          </div>
          <div v-else >
            {{show_make_block}}
            <div>{{ show_make_block.val.name }} true</div>
            <div>first select itme</div>
            <div>second select itme</div>
            <button class="btn" @click="save_block"> save </button>
          </div>

          <button>import</button>
          <button>export</button>
        </div>
        <div class="block_ctl wrap_area">
          <div class="maked_block_list" >
            <p> 만들어진것 -> 드래그쪽으로 세이브버튼을 옮겨야할듯 </p>
            <div class="block"  v-for="(val, key) in $store.state.trade_data_controller" >
              <button @click="select_block_stat(true, key, val)">
                {{key}} // {{val.status}} // {{val.name}}
              </button>
            </div>
            <div @click="select_block_stat( true,null, null)">
              <button>make new</button>
            </div>
          </div>
          <div class="block_select_used">
            <div class="block"> 이름1 </div>
          </div>
          <button class="btn"> save </button>
        </div>


        <div class="block_res_wrap wrap_area">
          <button>run</button>
          <div class="block_res"
          >
            <div class="block_res_input"

            >
              <p>all block</p>
              <div class="block"
                   draggable="true"

                   @drag="drag"
                   @dragend="dragend"
                   @dragenter="dragenter"
                   @dragexit="dragexit"
                   @dragleave="dragleave"
                   @dragover="dragover"
                   @dragstart="dragstart"
                   @drop="drop"

                   v-if="val.status === false"
                   v-for="(val, key) in $store.state.trade_data_controller"
              >
                {{key}} // {{val.name}} // {{val.status}}
              </div>
            </div>
            <div class="block_res_output"

                 draggable="false"

                 @drag="drag"
                 @dragend="dragend"
                 @dragenter="dragenter"
                 @dragexit="dragexit"
                 @dragleave="dragleave"
                 @dragover="dragover"
                 @dragstart="dragstart"
                 @drop="drop">

              <p>filtered block</p>
              <div class="block"

                   draggable="true"

                   v-if="val.status === true"
                   v-for="(val, key) in $store.state.trade_data_controller"
              >
                {{key}} // {{val.name}} // {{val.status}}
              </div>
            </div>
          </div>
        </div>

        <div class="block_res_wrap wrap_area">

          <button>result</button>
          <p> 결과값 미리보기 </p>
        </div>


      </div>
    </v-card>
  </v-dialog>
</template>


<script>

// import '../assets/css/dialog/trade_controller.css';
import '../../../assets/css/dialog/trade_controller2.css';

  export default {
    name: "trade_controller2",
    data () {
      return {


        selected_level:[],
        level: ['S+','S','A','B','C','D','F'],

        dialog: false,
        notifications: false,
        sound: true,
        widgets: false,

        // show_make_block: false,
        show_make_block: {
          show: false,
          key: null,
          val: null
        },
        maked_block:{
          name:null,
          type:null,
          stat:[],
          status:false,
        }

      }
    },
    methods:{
      select_block_stat(show, key, val){
        this.show_make_block = {
          show: show,
          key: key,
          val: val
        }
      },


      save_block(){
        let maked_block = this.maked_block
        console.log('maked_block', maked_block)
        console.log('before this.$store.state.trade_data_controller', this.$store.state.trade_data_controller)
        this.$store.state.trade_data_controller.push(maked_block)

        console.log('after this.$store.state.trade_data_controller', this.$store.state.trade_data_controller)
      },

      drag(e){
        // console.log('drag', e)
      },
      dragend(e){
        // e.target.style.opacity = 1;
      },

      dragenter(e){
        // console.log('ondragover', e)
      },
      dragexit(e){

        // console.log('dragexit', e)
      },

      dragleave(e){

        // console.log('onDragLeave', e)
      },
      dragover(e){
        e.preventDefault()
        // console.log('dragover e', e)


      },
      dragstart(e){

      },
      // drop(e){
      drop(e) {
        // e.preventDefault();

        console.log('drop e', e)

      },
    }
  }


</script>

<style scoped>

</style>
