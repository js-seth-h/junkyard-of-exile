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
<!--            {{this.$store.state.trade_data_controller.used_filters}}-->
<!--            <button class="btn" @click="show_block_detail('new')">add new</button>-->

            <input type="file" @change="import_selected_filter()" id="fileUpload" />

            <button class="btn" @click="add_block_or_filter('block', 'boolean')">add new</button>
          </div>
          <div class="filter_box" v-for="(filter_wrap_val, filter_wrap_key) of trade_data_controller.all_blocks">
            {{filter_wrap_val.block_name}}
            {{filter_wrap_key}}
            <button class="btn" @click="add_block_or_filter('filter', filter_wrap_key)"> b_add </button>
            <button class="btn" @click="remove_block_or_filter('block', [filter_wrap_key, 'boolean'])"> b_remove </button>
            <button class="btn" @click="duplicate_block_or_filter('block', filter_wrap_key)"> b_duplicate </button>
            <button class="btn"  @click="select_block_or_filter('block', filter_wrap_val)"> b_select </button>
            <div class="filter" v-for="(filter_val, filter_key) of filter_wrap_val.filters">

              <button class="btn" @click="remove_block_or_filter('filter', [filter_wrap_key, filter_key])"> f_remove</button>
              <button class="btn" @click="select_block_or_filter('filter', filter_val)"> f_select </button>
              <button class="btn" @click="duplicate_block_or_filter('filter', filter_key)"> b_duplicate </button>
              {{filter_val.filter_name}} <br /> {{filter_val.exp}} <br /> {{filter_val.status}}
              <button class="btn_show_detail btn"
                      @click="show_block_detail('filter' ,filter_val)"
              >
                show detail2
              </button>
            </div>
          </div>
        </div>

        <div class="content box_wrap">
          <div class="selected_block_wrap">
            <div v-if="used_filter === null">
              The filter is empty. Choose your filter
            </div>
            <div class="selected_block" v-else v-for="(used_filter_val, used_filter_key) of used_filter">
              {{used_filter_val.filter_name}} <br /> {{used_filter_val.exp}} <br /> {{used_filter_val.status}}
              <button class="btn_show_detail btn" @click="show_block_detail('filter', used_filter_val)">show detail - 사용안함</button>
            </div>
          </div>
          <div class="result">
            res text
<!--            {{filter_result}}-->

            <div v-if="filter_result.length > 0">
              <div v-for="(filter_result_val, filter_result_key) in filter_result">
                {{filter_result_val.item_data.header.lines}}
              </div>
            </div>
            <button class="btn" @click="run_selected_filter('saved')">saved item list data run</button>
            <button class="btn" @click="run_selected_filter('list')">item list data run</button>
            <button class="btn" @click="export_selected_filter()">export</button>


            <button class="btn" @click="apply_filter()">Apply selected filter to item list</button>

          </div>
        </div>



        <div class="block_detail box_wrap" v-show="block_detail_show"
             :class="[
                 block_detail_show === false?'off' : 'on' ,
                 block_detail_fullscreen === false ? '':'full'
             ]"
        >

          <button class="btn" @click="block_detail_fullscreen = !block_detail_fullscreen">full Screen :  {{block_detail_fullscreen}}</button>

          <button class="btn" @click="selected_filter_data = 'boolean', block_detail_show = false">close detail</button>

          <br />
          <!--          <button  class="btn"  @click="parsing_exp(selected_filter_data)">parsing_exp</button>-->
          <!--          <button  class="btn"  @click="make_exp()">make_exp</button>-->
          <!--          <button  class="btn"  @click="make_slide()">make_slide</button>-->





          <div v-if="selected_filter_data !== 'boolean'">
            <div v-if="selected_filter_data.status === false">
              <!--              <div v-if="selected_filter_data.position[0] !== null">-->
              <!-- 블록 리스트 -->
              <!--              <p>&#45;&#45;&#45;&#45;test1 - 리스트&#45;&#45;&#45;&#45;</p>-->
              <!--              {{trade_data_controller.all_blocks[selected_filter_data.position[0]].block_name}}-->
              <!--              <br />-->


              selected_filter_data: {{selected_filter_data}}

              <p>//////////////////////</p>
              <!--              <p>1: {{selected_filter_data.filter_name}}</p>-->
              <!--              <p>2: {{selected_filter_data.status}}</p>-->
              <!--              <p>3: {{selected_filter_data.exp}}</p>-->
              <!--              <p>4: {{selected_filter_data.parsed_data}}</p>-->



              <label for="filter_name">selected_filter_data.filter_name :</label>
              <input type="text" style="border:1px solid #fff; color: #fff;" name="filter_name" id="filter_name" :value="selected_filter_data.filter_name">
              <br /><br />
              <label for="exp">selected_filter_data.exp :</label>
              <input type="text" style="border:1px solid #fff; color: #fff;" name="exp" id="exp" :value="selected_filter_data.exp">
              <br /><br />
              <label for="parsed_data">selected_filter_data.parsed_data :</label>
              <input type="text" style="border:1px solid #fff; color: #fff;" name="parsed_data" id="parsed_data" :value="selected_filter_data.parsed_data">

              ///////////////

              <p>selected_filter_data : {{selected_filter_data}}</p>
              ///////////////
              <br /><br />

              <!--              5: detail_default_data: {{detail_default_data}}<br />-->
              <!---->
              <!--              6: <br />-->
              <br /><br />
              <div>
                <label for="data_F">F :</label>
                <input type="text" style="border:1px solid #fff; color: #fff;" name="data_F" id="data_F" v-model="selected_filter_data.parsed_data.F">
                <br />
                <label for="data_P">P :</label>
                <input type="text" style="border:1px solid #fff; color: #fff;" name="data_P" id="data_P" v-model="selected_filter_data.parsed_data.P">


              </div>
              <br />

              mods: <br />{{selected_filter_data.parsed_data.mods}}
              <br />


              <label for="slider_data_count">slider data count :</label>
              <input type="text"
                     style="border:1px solid #fff; color: #fff;"
                     name="slider_data_count"
                     id="slider_data_count"
                     v-model="selected_filter_data.parsed_data.mods.count"
              >

              <v-range-slider
                  :tick-labels="detail_default_data.level"
                  v-model="selected_filter_data.parsed_data.mods.slider"
                  :color="detail_default_data.selected_color"
                  :track-color="detail_default_data.unselected_color"
                  min="0"
                  max="6"
                  ticks="always"
                  tick-size="4"
              >
              </v-range-slider>

              <!--              <v-range-slider-->
              <!--                  :tick-labels="detail_default_data.level"-->
              <!--                  :value="selected_filter_data.parsed_data.mods.slider"-->
              <!--                  :color="detail_default_data.selected_color"-->
              <!--                  :track-color="detail_default_data.unselected_color"-->
              <!--                  min="0"-->
              <!--                  max="6"-->
              <!--                  ticks="always"-->
              <!--                  tick-size="4"-->
              <!--              >-->
              <!--              </v-range-slider>-->
              <!--              -->

            </div>
            <div v-else>
              <!-- 선택된 블록 리스트 -->

              <p>----test2 - 필터----</p>
              selected_filter_data:<br />
              {{selected_filter_data}}
            </div>
          </div>

          <button class="btn" @click="save_block_detail">save</button>

        </div>

      </div>
    </v-card>
  </v-dialog>
</template>


<script>

// import '../assets/css/dialog/trade_controller.css';
import '../../../assets/css/dialog/trade_controller.css';
import store from "../../../store";

export default {
  name: "trade_controller",
  data () {
    return {


      storage_data: JSON.parse(localStorage.getItem('storage_data')),

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
      block_detail_fullscreen: false,

      maked_block:{
        filter_name:'boolean',
        name:'boolean',
        type:'boolean',
        stat:[],
        status:false,
      },

      selected_filter_data: 'boolean',


      filter_result :[],
    }
  },
  computed: {
    trade_data_controller() {
      // console.log('----------------------this.$store.state.list_data', this.$store.state.trade_data_controller)
      return this.$store.state.trade_data_controller
      // return JSON.parse(localStorage.getItem('storage_data'))
    },
    used_filter(){
      return JSON.parse(localStorage.getItem('used_filters'))
    },
  },
  methods:{
    apply_filter(){

    },
    remove_block_or_filter(type, key){
      console.log('type:', type, 'key: ', key)
      let saved_blocks = this.trade_data_controller.all_blocks

      if(type === 'block'){
        console.log('block - default - saved_blocks', saved_blocks)

        saved_blocks = saved_blocks.splice(key[0],1)
      }else{

        saved_blocks = saved_blocks[key[0]].filters.splice(key[1],1)
      }
      console.log('saved_blocks', saved_blocks)
    },
    run_selected_filter(type){

      var storage_data = ''
      if(type === 'saved'){
      //  saved: local storage saved item lsit
        storage_data = this.storage_data
        // let filter_data = this.trade_data_controller.used_filters
      }else{
      //  list: store save item list
        storage_data = this.$store.state.list_data
      }

      console.log('click - run_selected_filter // type: ' ,type )
      // let filter_data = this.trade_data_controller.used_filters
      let filter_data = this.used_filter
      let P, F =''
      this.filter_result = []
      this.loop_filter(storage_data, filter_data)

    },

    loop_filter(storage_data, filter_data) {
      console.log('test loop', filter_data, '//', storage_data);


      storage_data.map(x => {

        filter_data.map(data => {

          let parsed_filter_data = this.parsing_exp(data.exp)

          let F = x.item_data.fullness
          let P = x.item_data.power
          console.log('x', x,'///x',x.rating, '//', 'data', data, '//', 'parsed_filter_data', parsed_filter_data )

          //parsed_filter_data.mods.level
          let this_level = parsed_filter_data.mods.level
          let position_to_arr = parsed_filter_data.mods.slider
          let level_count = parsed_filter_data.mods.count

          let parsed_rating = this.parse_level(x.rating)


          // const result = words.filter(word => word.length > 6);

          // x.rating (6) ["D", "C", "D", "F", "A", "C", __ob__: Observer]
          // this_level (2) ["D", "D"]
          // position_to_arr (2) [5, 5]
          // parsed_rating (6) [5, 4, 5, 6, 2, 4]
          // level_count 2

          let filter_option = (val => {
            let stat = false
            if(position_to_arr[0] >= val && position_to_arr[1] <= val) {
              stat = true
            }
            return stat
          })

          console.log(parsed_rating.filter(filter_option), '////', parsed_rating.filter(filter_option) === true );
          //필터를 통과한 데이터
          if(parsed_rating.filter(filter_option).length >= level_count ){
            let cloned_data = JSON.parse(JSON.stringify(x))
            // cloned_data.push()
            this.filter_result.push(cloned_data)
          }

          console.log('filter_option', filter_option)
          console.log('x.rating', x.rating , '//','this_level', this_level, 'position_to_arr', position_to_arr, 'parsed_rating', parsed_rating, 'level_count', level_count)

        })

      })

      let val = false

      if (val === false) {
        return false // 종료 조건
      }

    return this.loop_filter(storage_data) // 재귀함수
  },

    async import_selected_filter(){
      console.log('click - import_selected_filter')
      const fileInput = document.getElementById("fileUpload");

      // const selectedFile = fileInput.files[0];
      var selectedFile = JSON.parse(await fileInput.files[0].text());

      console.log(selectedFile);

      // this.add_block_or_filter('block', )

      let blocks = {
        block_name:'내 블록 리스트11111',
        filters:selectedFile
      }

      console.log('ablocks', blocks)
      let tdc = this.$store.state.trade_data_controller

      console.log('tdc', tdc)
      tdc.all_blocks.unshift(blocks);

    },

    export_selected_filter(){
      console.log('click - export_selected_fitler')
      let used_filters = this.trade_data_controller.used_filters;
      if(used_filters.length === 0){
        alert('Please choose a filter first')
      }else{

        console.log('used_filters', used_filters)

        used_filters.map(x=>{
          delete x.position
        })
        this.file_download(used_filters)
      }
    },

    file_download(data){

      let content = JSON.stringify(data)

      const blob = new Blob([content], {type: 'text/plain'})
      const url = window.URL.createObjectURL(blob)
      const a = document.createElement("a")
      a.href = url
      // a.download = `${this.$store.state.nickname}_${this.title}.md`
      a.download = `JOE_filter_export.js`
      a.click()
      a.remove()
      window.URL.revokeObjectURL(url);
    },


    duplicate_block_or_filter(type, key){
      let tdc = this.$store.state.trade_data_controller

      console.log('type, key', type, '//', key)

      if(type === 'block'){

      }else{

      }

    },
    add_block_or_filter(type, key){
      let tdc = this.$store.state.trade_data_controller

      var block_form = {}
      console.log('tdc', tdc, '//', tdc.all_blocks.length)
      console.log('type, key', type, key)
      if(type === 'block'){
        block_form = {
          block_name: 'block list - '+tdc.all_blocks.length,
          filters: []
        }
        tdc.all_blocks.unshift(block_form);
      }else{

        console.log('tdc[key]', tdc.all_blocks[key], '//',tdc.all_blocks)

        // Array.prototype.push.apply(tdc.all_blocks, block_form);
        block_form = {
          filter_name:'block - ' + tdc.all_blocks[key].filters.length,
          status: false,
          exp: " / / A and D > ",

        }
        console.log('tdc.all_blocks', tdc.all_blocks[key].filters.length)

        tdc.all_blocks[key].filters.unshift(block_form);

        console.log('tdc.all_blocks', tdc.all_blocks)

      }
    },

    select_block_or_filter(type, val){

      var filters, position = ''
      console.log('va222l:', val)


      val = JSON.parse(JSON.stringify(val))

      if(type === 'block'){
        position  = val.block_name
        console.log('val'. val)
        filters = val.filters

        console.log('~~~~~~~~~~~~~~ filters: ', filters)
        position = ['block' ,position]

        filters = filters.map( x =>  {
          x.status = true
          Object.assign(x, {position:position})
          return x;
        })

      }else{
        //filter
        position  = val.filter_name
        console.log('filter val', val)

        position = ['filter' , position]

        val.status = true
        val.position = position

        filters = val

      }

      console.log('filters', filters)


      if(type === 'block'){
        if (window.confirm("Are you sure you want to change all filter lists??")) {
          this.$store.dispatch('replace_trade_used_filter', filters)
        }

      }else{
        this.$store.dispatch('add_trade_used_filter', filters)
      }


    },

    show_block_detail(type, val){

      console.log('val: ' , val, '//', 'type: ', type)
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

      console.log('test type ', type)
      let position = []

      console.log('data', data)
      if(type === 'block'){
        position = [type, data.block_name]
      }else{
        position = [type, data.filter_name]
      }
      this.selected_filter_data = Object.assign(data, {position: position})

      console.log('%%%%%%%%%%%%%%%%%%%   selected_filter_data ----      ', this.selected_filter_data)
      this.parsing_exp(this.selected_filter_data.exp)

      console.log('selected_filter_data', this.selected_filter_data)
    },

    make_slide(test){
      // make_slide(data){

      console.log('^^^^^^^^^^^^^^^^^^^^    ', this.selected_filter_data)
      let data = this.selected_filter_data.mods
      // let data = "F>3.3 / P>2.3 / A+ and D > 1"
      // this.selected_filter_data
      console.log('------- data1111: ', data)
      // let parsed = this.parsing_exp(data.exp)
      let parsed = this.parsing_exp(data)
      let level = this.slider_level
      console.log('------- parsed222: ', parsed)


      let test_data = JSON.parse(JSON.stringify(parsed.mods[0]))
      console.log('test_data', test_data , '//', test_data)

      if(test_data){
        console.log('test_data-----------true', test_data )
      }else{
        console.log('test_data-----------false', test_data )
      }

    },
    make_exp(){
      console.log('make_exp - ',data)
      console.log('------- this.selected_filter_data: ', this.selected_filter_data)
      // this.selected_filter_data.parsed_data
      let data = this.selected_filter_data.parsed_data.mods
      let parsed = this.parsing_exp(this.selected_filter_data.exp)
      // data = "F>3.3 / P>2.3 / A+ and D > 1"

      console.log('------- parsed: ', parsed)



    },
    parsing_exp(data){

      console.log('/////////////',data)
      let edge_slider = this.edge_slider_option
      let level = this.slider_level
      // <, > 를 기준으로 분리하기위해 선언해둔 변수
      let reg_carret = /[<>]/gi;

      let parsed_data = this.parsed_data
      // data를 / 기준으로 분리

      console.log('---------------11111', data, '//', parsed_data)
      let stat = data.split(/[/]/gi);



      console.log('data: ', data, '//'
          , 'parsed_data: ', parsed_data, '//'
          , 'stat: ', stat, '//'
          , 'reg_carret: ', reg_carret, '//')

      function parse_exp(data){
        // trim()
        // data = data.replace(/\s+/g, '');

        data = data.replace(/\s+/g, '');
        const splited_data = data.split(reg_carret)
        return { [splited_data[0]] : splited_data[1]}
      }





      console.log(';;;;;;;;;;;;;;', stat)
      let stat_tuple = stat;
      let [parse_F, parse_P, parse_mods] = stat_tuple


      // let parse_F = parse_exp(pf)
      // let parse_P = parse_exp(pp)
      // let parse_mods = parse_exp_mods(pm)

      // parse_exp

      // this.parsed_data = Object.assign({}, parse_exp(parse_F), parse_exp(parse_P), parse_exp_mods(parse_mods))
      const assignd_data = Object.assign({}, parse_exp(parse_F), parse_exp(parse_P), this.parse_exp_mods(parse_mods))

      // this.parsed_data = [parse_F, parse_P, parse_mods]

      console.log('***************this.parsed_data',this.parsed_data)

      console.log('parse_P: ', parse_P, '//', 'parse_F: ',parse_F, '//', 'parse_mods: ', parse_mods )


      if(this.parsed_data ==! 'boolean'){
        this.selected_filter_data.parsed_data = assignd_data
      }


      return assignd_data

    },

    parse_exp_mods(data){

      let reg_carret = /[<>]/gi;

      data = data.replace(/\s+/g, '');
      console.log('1111111zzzz', data)

      let test0 = data.split(reg_carret)
      test0 = test0[0].split('and')
      let test1 = data.split('>')[1]
      console.log('test0: ', test0, 'test1: ', test1)


      let test_carret = /(and)|[<>]/gi;

      let splited_data = []
      splited_data = data.trim().split(reg_carret)

      const splited_level = splited_data[0].split('and')

      let selected_level = [splited_level[0], splited_level[1]]

      let parsed_level = this.parse_level(selected_level)

      let assignd_data = Object.assign({},
          {level: selected_level},
          {count: splited_data[1]},
          {slider: parsed_level}
      )

      return { mods:assignd_data }
    },


    parse_level(val) {
      console.log('xxxxxxxxxxxxxx - ', val)

      let level = this.slider_level

      // indexof
      // map]
      let level_position = []
      val.map(x=>{
        level_position.push(level.indexOf(x))
      })


      console.log('^^^^^^^^^^^^^^^^^level:',level,'\nlevel_position:', level_position , '\nval:', val)

      return level_position
    },

    check_duplicated_name(type, value){
      // block name, filter name

      // value = (tdc, payload)
      // lettype = value.type

      console.log('value', value)
      let tdc = value.tdc.all_blocks
      let data = value.payload

      var all_names = []
      var target_names = []

      //get all_names
      tdc.map( x =>  {
        all_names.push(x.block_name)

        x.filters.map( x =>  {
          all_names.push(x.filter_name)
        })

      })

      // //get target_names
      // if(type === 'block'){
      //   target_names = data.filters.map( x => target_names.push(x.filter_name))
      // }else{
      //   target_names = data.filters.position[1]
      // }
      //
      // let concat_names = all_names.concat(target_names);
      //
      // let test = [...new Set(concat_names)];

      // console.log('test', test)
      // https://ko.javascript.info/map-set

      const set1 = new Set([1, 2, 3, 4, 5]);

      console.log(set1.has(1));
      // expected output: true


      return true
    },

    get_name_position(value){
      // val.type val.position_name

      // value = (tdc, payload)
      // lettype = value.type

      let type = value[0]
      let position = value[1]



      console.log('value', value)
      let tdc = this.$store.state.trade_data_controller.all_blocks
      // let data = value.payload
      var all_names = []
      var target_names = []

      // tdc.map( (val,key) => console.log(val.block_name) )

      // let test = map.set(value.position)

      var position_num = []


      console.log('tdc', tdc)
      console.log('value.position', value)

      console.log('function position' ,position_num)

      if(type === 'block'){
        tdc.map( (val,key) =>{
          if(val.block_name === position){
            position_num.push(key)
          }
        })
      }else{
        tdc.map( (val,key) =>{
          console.log(val.block_name)
          // if(val.block_name === position){
          //   position_num = key
          // }


          console.log('position_num00000', position_num)
          console.log('val',val, 'key', key)
          val.filters.map( (filter_val, filter_key) =>  {
            console.log('filter_val', filter_val, 'filter_key', filter_key)
            if(filter_val.filter_name === position){

              position_num = Array.of(key)
              position_num.push(filter_key)

              return position_num
              console.log('position_num99999', position_num)
            }
          })

        })

        console.log('position_num99999', position_num)
      }
      //get all_names
      // tdc.map( x =>  {
      //   all_names.push(x.block_name)
      //
      //   x.filters.map( x =>  {
      //     all_names.push(x.filter_name)
      //   })
      //
      // })

      // //get target_names
      // if(type === 'block'){
      //   target_names = data.filters.map( x => target_names.push(x.filter_name))
      // }else{
      //   target_names = data.filters.position[1]
      // }
      //
      // let concat_names = all_names.concat(target_names);
      //
      // let test = [...new Set(concat_names)];

      // console.log('test', test)


      return position_num
    },


    save_block_detail(){
      let data = this.selected_filter_data
      // let data = this.selected_filter_data
      console.log('this.selected_filter_data-------------', data)
      if(data.position !== 'undefined' ){

        if(data.position[0] === null){
          console.log('사용중 필터 - 저장 불가')
        }else{
          console.log('사용중이지 않은 필터 - 저장 가능')




          let level = this.slider_level

          let slider_position = []

          console.log(data.parsed_data.mods.slider)
          data.parsed_data.mods.slider.map(x=>{
            console.log('x: ', x)

            level.map((val,key)=>{

              console.log('val: ', val, 'key: ', key)
              if(key === x){
                slider_position.push(val)
              }
            })
            // position.push(level.indexOf(x))
            //
            // for (const slider_position in data.parsed_data.mods.slider) {
            //   if(slider_position === key){
            //     after_slider_position.push(val)
            //   }
            // }
          })

          console.log('slider_position', slider_position)
          data.parsed_data.mods.level = slider_position



          console.log('this.selected_filter_data-------------2', data)

          let assignd_exp = data_to_exp(data.parsed_data)

          function data_to_exp(data){
            let F =data.F
            let P =data.P
            let level =data.mods.level
            let count =data.mods.count



            const assignd_exp = "F>" + F + ' / ' + "P>" + P + ' / ' + level[0] + ' and '+ level[1] + ' > ' + count

            console.log('assignd_exp:', assignd_exp)

            return assignd_exp
          }


          let position_num = this.get_name_position(data.position)

          // data.position
          console.log('position', data.position)
          console.log(this.$store.state.trade_data_controller.all_blocks)
          const get_position_from_data = this.$store.state.trade_data_controller.all_blocks[position_num[0]].filters[position_num[1]]

          get_position_from_data.exp = assignd_exp

          console.log('outer assignd_exp', assignd_exp)
          console.log('get_position_from_data', get_position_from_data)


        }

      }else{
        alert('error occured')
        this.block_detail_show = false;
        this.selected_filter_data = 'boolean'
      }
    },
  }
}


</script>

<style scoped>

</style>
