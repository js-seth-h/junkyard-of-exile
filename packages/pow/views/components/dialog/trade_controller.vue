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
        Open Dialog
      </v-btn>
    </template>
    <v-card
        id="trade_controller">
      <v-toolbar
          dark
          color="primary"
      >
        <v-toolbar-title>Junkyard of Exile</v-toolbar-title>
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

        <div class="filter_box_wrap box_wrap">
          <div>
            <button class="btn" @click="show_block_detail('new')">add new</button>
          </div>
          <div class="filter_box" v-for="(filter_wrap_val, filter_wrap_key) of trade_data_controller.all_blocks">
            {{filter_wrap_val.block_name}}
            <button @click=""> add block</button>
            <div class="filter" v-for="(filter_val, filter_key) of filter_wrap_val.filters">
              {{filter_val.filter_name}} <br /> {{filter_val.exp}}
              <button class="btn_show_detail btn"
                      @click="show_block_detail(filter_val, [filter_wrap_key,filter_key])"
              >
                show detail2
              </button>
            </div>
          </div>
        </div>

        <div class="content box_wrap">
          <div class="selected_block_wrap">

            <div class="selected_block" v-for="(used_filter_val, used_filter_key) of trade_data_controller.used_filters">
              {{used_filter_val.filter_name}} <br /> {{used_filter_val.exp}}
              <button class="btn_show_detail btn" @click="show_block_detail(used_filter_val,[null,used_filter_key])">show detail - 사용안함</button>
            </div>
          </div>
          <div class="result"> res text</div>
        </div>



        <div class="block_detail box_wrap" v-show="block_detail_show" :class="block_detail_show === false?'off' : 'on'" >
          <button class="btn" @click="selected_filter_data = 'boolean', block_detail_show = false">close detail</button>

          <br />
          <button  class="btn"  @click="parsing_exp('test')">parsing_exp</button>

          <div v-if="selected_filter_data !== 'boolean'">
            <div v-if="selected_filter_data.position[0] !== null">
              <!-- 블록 리스트 -->
              <p>----test1----</p>
              {{trade_data_controller.all_blocks[selected_filter_data.position[0]].block_name}}


              <br />
              <br />
              {{selected_filter_data}}

            </div>
            <div v-else>
              <!-- 선택된 블록 리스트 -->

              <p>----test2----</p>
              {{selected_filter_data}}
            </div>
          </div>

          <p>------------------------------------------------</p>

          <br />
          detail data
          <br />
          <input type="text" placeholder="3" :value="selected_filter_data.filter_name" style="color:#fff;">
          <br />

          <div style="display: flex">
            <input type="text" placeholder="3">
            <input type="text" placeholder="2">
          </div>

          <button class="btn" @click="a = !edge_slider_option"> slider button edge_slider_option:{{edge_slider_option}}</button>
          <div class="slider_wrap">
            <div v-if="edge_slider_option === true">
              <v-range-slider
                  :tick-labels="detail_default_data.level"
                  :value="detail_default_data.selected_level"
                  :color="detail_default_data.unselected_color"
                  :track-color="detail_default_data.selected_color"
                  min="0"
                  max="6"
                  ticks="always"
                  tick-size="4"
              >
              </v-range-slider>
            </div>
            <div v-else>
              <v-range-slider
                  :tick-labels="detail_default_data.level"
                  :value="detail_default_data.selected_level"
                  :color="detail_default_data.selected_color"
                  :track-color="detail_default_data.unselected_color"
                  min="0"
                  max="6"
                  ticks="always"
                  tick-size="4"
              >
              </v-range-slider>
            </div>
          </div>






          <br />
          selected_filter_data: {{selected_filter_data}}

          <div>
            <input placeholder="블록 리스트 이름">
            <div>
              <input placeholder="블록 이름">
              <br />
              F: <input v-model="maked_block.name">
<!--              F: <input placeholder="3.9">-->
              <br />
              <div>
                s+, s, A ~~~
              </div>

              <div class="select_level_combobox">
                <v-combobox
                    v-model="maked_block.stat"
                    :items="detail_default_data.level"
                    label="Choose an item that includes level type."
                    multiple
                    chips

                ></v-combobox>
              </div>

              <br />
              <br />
              P: <input placeholder="2.3">
              <br />
              <div>
                s+, s, A ~~~
              </div>


            </div>
          </div>
<!--          <button class="btn" @click="save_block_detail = false">save</button>-->
          <button class="btn" @click="save_block_detail()">save</button>

        </div>

      </div>
    </v-card>
  </v-dialog>
</template>


<script>

// import '../assets/css/dialog/trade_controller.css';
import '../../../assets/css/dialog/trade_controller.css';

export default {
  name: "trade_controller",
  data () {
    return {

      dialog: false,
      notifications: false,
      sound: true,
      widgets: false,

      // filter data psrsing
      parsed_data: { F:'', P:'', mods: [] },



      //슬라이드 색깔
      selected_color: 'orange darken-3',
      unselected_color:'gray',
      // slide_wrap

      //
      edge_slider_option: true,
      slider_level: ['S+','S','A','B','C','D','F'],


      detail_default_data:{
        selected_level: [2, 3],
        level: ['S+','S','A','B','C','D','F'],
        selected_color: 'orange darken-3',
        unselected_color:'gray',

      },
      block_detail_show :false,

      maked_block:{
        filter_name:'boolean',
        name:'boolean',
        type:'boolean',
        stat:[],
        status:false,
      },

      selected_filter_data: 'boolean',

    }
  },
  computed: {
    trade_data_controller() {
      console.log('----------------------this.$store.state.list_data', this.$store.state.trade_data_controller)
      return this.$store.state.trade_data_controller
    },
  },
  methods:{

    show_block_detail(val, key){

      console.log('val: ' , val, '//', 'key: ', key)
      // let data = new Object()

      val = JSON.parse(JSON.stringify(val))
      let data = val


      if(val === 'undefined' || val === 'new'){
        data = 'boolean'
      }else{
        data = val
      }

      this.block_detail_show = true;


      // this.selected_filter_data = data
      this.selected_filter_data = Object.assign(data, {position: key})

    },
    make_exp(data){
      console.log('make_exp - ',data)

      data = "F>3.4 and A+>2 and D-<0 and P>2.3"


    },
    parsing_exp(data){
      let edge_slider = this.edge_slider_option
      let level = this.slider_level

      if(edge_slider === true){
        data = "F>3.4 / P>3.4 / A+>2 and D<0"

      }else{
        // data = "B<2 and C>1"
        data = "F>3.4 / P>3.4 / A+>2 and D<0"
      }


      let parsed_data = this.parsed_data
      let stat = data.split(/[/]/gi)
      let reg_carret = /[<>]/gi

      // exp F data
      if(stat[0].length > 0){
        const splited_data = stat[0].split(reg_carret)
        this.parsed_data.F = splited_data[1]
      }
      // exp P data
      if(stat[1].length > 0){
        const splited_data = stat[1].split(reg_carret)
        this.parsed_data.P = splited_data[1]
      }

      // exp P slider data
      if(stat[2].length > 0){
        let splited_data = stat[2].split('and')
        console.log('splited_data', splited_data)
        // splited_data = splited_data.replace(/\s+/g, '');

        // splited_data.map(val => {
        //
        //   val = val.replace(/\s+/g, '');
        //
        //   const carrret_splited_data = val.split(reg_carret);
        //   const mods_data = { [carrret_splited_data[0]] : carrret_splited_data[1]}
        //
        //   this.parsed_data.mods = Object.assign(this.parsed_data.mods, mods_data)
        // });

        this.parsed_data.mods.push(splited_data)
        console.log()

      }


      console.log('parsed_data --- ', this.parsed_data)
    },
    save_block_detail(){
      let data = this.selected_filter_data
      // let data = this.selected_filter_data
      console.log('save_block_detail: ' , data)
      if(data.position !== 'undefined' ){

        // {
        //   filter_name:'블록2-1',
        //       status: true,
        //     exp: "F>3.6 and A+>2 and D-<0 and P>2.3",
        // }
        this.make_exp(data)
        this.parsing_exp(data)

        if(data.position[0] === null){
          console.log('사용중 필터 - 저장 불가')
        }else{
          console.log('사용중이지 않은 필터 - 저장 가능')

          // this.$store.state.trade_data_controller.all_blocks[data.position[0]].[data.position[1]]
          console.log('data.position[0]', data)

          console.log('selected_filter_data', this.selected_filter_data)
        }


        // let test = data.map((data, key) => console.log('111111111111', data))

        // console.log('test', test)
      }else{
        alert('error occured')
        this.block_detail_show = false;
        this.selected_filter_data = 'boolean'
      }
      // if(val === 'undefined' || val === 'new'){
      //   data = 'boolean'
      // }else{
      //   data = val
      // }

      // this.block_detail_show = true;
      // this.selected_filter_data = data

    },
  }
}


</script>

<style scoped>

</style>
