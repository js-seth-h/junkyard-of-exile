<template>
  <div class="trade_wrap" id="trade_wrap" >

    <!--    <v-app>-->

    <button class="trade_btn" @click="trade_content = !trade_content"> + </button>
    <div class="wrapper">
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
    <div class="trade_content" v-show="trade_content" style="margin-left: 50px; display: flex">

      <div id="trade_use" style="display: inline-block;">
        <div
            v-if="item.status === true" v-for="(item, key) of trade_data"
            :key="key"
            v-bind:id="'wrap_'+item.id"
        >
          <div class="trade_item"

               draggable="true"
               @drag="drag"
               @dragend="dragend"
               @dragenter="dragenter"
               @dragexit="dragexit"
               @dragleave="dragleave"
               @dragover="dragover"
               @dragstart="dragstart"
               @drop="drop"
               v-bind:id="item.id"
          >
            process: {{item.process}}//
            status: {{item.status}}//
            {{item.name}}

          </div>


        </div>
      </div>
      <div id="trade_unused" style="display: inline-block;">
        <div v-if="item.status === false" v-for="(item, key) of trade_data" :key="key"
        >
          <div class="trade_item"

               v-bind:id="item.id"
               draggable="true"
               @drag="drag"
               @dragend="dragend"
               @dragenter="dragenter"
               @dragexit="dragexit"
               @dragleave="dragleave"
               @dragover="dragover"
               @dragstart="dragstart"
               @drop="drop"
          >
            process: {{item.process}}//
            status: {{item.status}}//
            {{item.name}}

          </div>




        </div>
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
      dragged:{
        id: null,
        html: null,
      },
      drag_target:null,
      drag_status_ing: false,

    }
  },
  methods: {
    get_trade_data_for_id(id){
      let trade_data = this.$store.state.trade_data


      return data.map(m => ({data: data, key: key}))

      // for(let [key, data] of trade_data){
      //   if(id === data.id){
      //     // console.log(data.map(m => ({data: data, key: key})))
      //     return data.map(m => ({data: data, key: key}))
      //
      //   }
      // };

    },
    trade_data_splice(){
      // 중간에 삽입
      let data = {
        id: 'test11',
        name:'마음의 바늘 아로새긴 마법봉 11',
        status: false,
      }
      this.trade_data.splice(2, 0, data)
    },
    drag(e){
      // console.log('drag', e)
    },
    dragend(e){
      e.target.style.opacity = 1;
    },

    dragenter(e){

      e.dataTransfer.effectAllowed = "move";
      console.log('target_from_id', e.target.id)

      if(e.target.parentNode.parentNode.id === 'trade_use'){
        // e.target.style.paddingTop = "50px";

      }else{
        // trade_unused
        // e.target.style.paddingTop = "10px";
      }


      // e.target.style.background = "blue";

      // e.target.addClass = "item_over";
      console.log('ondragover', e)
    },
    dragexit(e){

      console.log('dragexit', e)
    },

    dragleave(e){

      console.log('-------------------------------- dragleave chk_blank_div', e.target.id === 'blank_div')

      console.log('!!!!-------------------------------- dragleave chk_blank_div//',e.relatedTarget.id,'//', e)
      // e.relatedTarget.id !== 'blank_div'


      // console.log('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!', chk_blank_div.parentNode)





      // if(! e.target.id.includes('wrap')){
      //   // 내부 컨텐츠만
      //
      //   // var make_blank_div = document.removeElement('div');
      //
      //   console.log('22222222222222222222222222222222222222222', e)
      //   var chk_blank_div = document.getElementById('blank_div');
      //
      //
      //
      // }

      // e.target.style.paddingTop = "10px";



      console.log('onDragLeave', e)
    },
    dragover(e){
      e.preventDefault()

      if(e.target.id === 'blank_div'){
        alert(1)
      }


      console.log('dragover target_id', e.target.id)


    },
    dragstart(e){
      this.dragged.html = e.target;
      this.dragged.id = e.target.id

      e.dataTransfer.setData('text/plain', e.target.id)


      console.log('e.target.id', e.target.id)

      // e.target.style.background = "yellow";
      // e.target.style.opacity = .5;
      console.log('dragstart', e)
    },
    // drop(e){
    drop(e, status) {

      console.log('drop000000000000000000000000000000000000',e)

      var target_id = status
      if (status === undefined) {
        status = null
        target_id = e.target.id
      }

      e.preventDefault();
      if (e.target.id.match("drag")){
        return;
      }

      // var data = e.dataTransfer.getData("text");
      // e.target.appendChild(document.getElementById(data));
      // stop();


      console.log('e.dataTransfer.getData',e.dataTransfer.getData('text'))
      // alert(2222222222222222)
      e.preventDefault();
      console.log('onDrop', e)

      let trade_data = this.$store.state.trade_data
      let trade_data2 = this.$store.state.trade_data2
      console.log('trade_data2', this.$store.state.trade_data2)
      console.log('trade_data', this.$store.state.trade_data)

      let status_data = null

      // var dragged_id = e.dataTransfer.getData('text')
      // dragged_id = this.dragged.id

      if(e.target.parentNode.parentNode.id === 'trade_use'){
        status_data = true
        console.log('11111111111111111111111111111111')
      }else{
        // trade_unused

        console.log('222222222222222222222222222222222')
        status_data = false
      }

      console.log('dragged', this.dragged.id)
      console.log('e.target.id', e.target.id)
      console.log('isNaN(status_data)', status_data)
      if(status_data !== null){
        console.log('3333333333333333333333333333333333333333')
        this.$store.state.trade_data = trade_data.map(
            p => p.id !== this.dragged.id ? p : {...p, status: status_data }
        )

        console.log('trade_data', trade_data)

        // trade_data2 = trade_data2.map(
        //     p => p.id !== e.target.id ? p : {...p, status: status_data}
        // )
      }

      console.log(trade_data.map(p => p.id === this.dragged.id))
      // if()
      //값의 변경이 잘 되었는지 확인 후 html 추가
      // e.target.before( this.dragged.html );



      console.log('444444444444444444444444444444444e.target', e.target.parentNode.parentNode.id)
      if(e.target.parentNode.parentNode.id === 'trade_use'){

        console.log('444444444444444444444444444444444')
        // e.target.after( this.dragged.html );
        // 배열 순서를 바꿔야겠음

        console.log('trade_data.lastIndexOf(e.target.id)', trade_data.lastIndexOf(e.target.id))

        // const isLargeNumber = (element) => element === e.target.id;


        // console.log('test', trade_data.map((value,index)=> {if( value.id === e.target.id){ return index} }));
        let target_entry = null
        let dragged_entry = null
        for (const [key, val] of Object.entries(trade_data)){
          if(target_id === val.id){
            // if(e.target.id === val.id){

            target_entry = key
          }

          if(this.dragged.id === val.id){
            dragged_entry = key
          }

        }
        console.log('dragged_item', dragged_entry)
        let dragged_item = this.$store.state.trade_data.splice(dragged_entry, 1);
        let target_item = this.$store.state.trade_data.splice(target_entry, 1);

        console.log('dragged_item', dragged_item[0], 'target_item', target_item[0])
        this.$store.state.trade_data.splice(target_entry, 1, dragged_item[0], target_item[0]);

        console.log('this.$store.state.trade_data', this.$store.state.trade_data)

      }else if(e.target.parentNode.parentNode.id === 'trade_unused'){
        console.log('555555555555555555555555555555555555')
        if(target_id !== this.dragged.id){
          // if(e.target.id !== this.dragged.id){


          // let test = null
          // this.$store.state.trade_data = trade_data.map(
          //     p => p.id !== this.dragged.id ? p : test = p
          // )
          // console.log('test', test)
          // this.$store.state.trade_data.push()

          let dragged_entry = null
          for (const [key, val] of Object.entries(trade_data)) {
            if(this.dragged.id === val.id){
              dragged_entry = key
            }
          }
          let dragged_item = this.$store.state.trade_data.splice(dragged_entry, 1);

          // this.$store.state.trade_data.splice(dragged_entry, 1);
          this.$store.state.trade_data.push(dragged_item[0])

          console.log('this.$store.state.trade_data11111', this.$store.state.trade_data)



        }
      }else{
        console.log('6666666666666666666666666666666')

        // e.target.append( this.dragged.html );
      }
      console.log('trade_data11111', trade_data)
      console.log('trade_data222222', this.$store.state.trade_data)


    }
  }

}
</script>

<style scoped>

</style>
