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
          <div class="filter_box" v-for="(filter_wrap_val,filter_wrap_key) of this.trade_data_controller.all_blocks">
            {{filter_wrap_val.block_name}}
            <div class="filter" v-for="(filter_val,filter_key) of filter_wrap_val.filters">
              {{filter_val.filter_name}}
              <button class="btn_show_detail btn" @click="swap_active_block_detail(true)">show detail</button>
            </div>
          </div>
        </div>

        <div class="content box_wrap">
          <div class="selected_block_wrap">
            <div class="selected_block">
              블록4
              <button class="btn_show_detail btn" @click="swap_active_block_detail(true)">show detail</button>
            </div>
            <div class="selected_block">
              블록5
              <button class="btn_show_detail btn" @click="swap_active_block_detail(true)">show detail</button>
            </div>
          </div>
          <div class="result"> res text</div>
        </div>
        <div class="block_detail box_wrap" v-show="this.block_detail_show" :class="block_detail_show === false?'off' : 'on'" >
          <button class="btn" @click="swap_active_block_detail(false)">close detail</button>
          detail data
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


        block_detail_show :false,

      }
    },
    computed: {
      trade_data_controller() {
        console.log('----------------------this.$store.state.list_data', this.$store.state.trade_data_controller)
        return this.$store.state.trade_data_controller
      },
    },
    methods:{
      swap_active_block_detail(val){
        console.log('////', val)

        this.block_detail_show = val;
        console.log('block_detail_show', this.block_detail_show, '////', val)
      }
    }
  }


</script>

<style scoped>

</style>
