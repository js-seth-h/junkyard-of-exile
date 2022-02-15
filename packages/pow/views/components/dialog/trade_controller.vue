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
        <div class="make_block wrap_area">
          <div>name</div>
          <div>first select itme</div>
          <div>second select itme</div>
          <button class="btn"> save </button>
          <button>import</button>
          <button>export</button>
        </div>
        <div class="block_ctl wrap_area">
          <div class="maked_block_list">
            <div class="block"> 이름2 </div>
            <div class="block"> 이름3 </div>
            <div>+</div>
          </div>
          <div class="block_select_used">
            <div class="block"> 이름1 </div>
          </div>
          <button class="btn"> save </button>
        </div>

        <div class="block_res wrap_area">
          <button>run</button>
          <div class="block_res_input">
            <p>all block</p>
            <div class="block"> 이름1 </div>
            <div class="block"> 이름2 </div>
            <div class="block"> 이름3 </div>
          </div>
          <div class="block_res_output">
            <p>filtered block</p>
            <div class="block"> 이름1 </div>
            <div class="block"> 이름2 </div>
          </div>
        </div>

      </div>
<!--      <v-list-->
<!--        three-line-->
<!--        subheader-->
<!--      >-->
<!--        <v-subheader>User Controls</v-subheader>-->
<!--        <v-list-item>-->
<!--          <v-list-item-content>-->
<!--            <v-list-item-title>Content filtering</v-list-item-title>-->
<!--            <v-list-item-subtitle>Set the content filtering level to restrict apps that can be downloaded</v-list-item-subtitle>-->
<!--          </v-list-item-content>-->
<!--        </v-list-item>-->
<!--        <v-list-item>-->
<!--          <v-list-item-content>-->
<!--            <v-list-item-title>Password</v-list-item-title>-->
<!--            <v-list-item-subtitle>Require password for purchase or use password to restrict purchase</v-list-item-subtitle>-->
<!--          </v-list-item-content>-->
<!--        </v-list-item>-->
<!--      </v-list>-->
<!--      <v-divider></v-divider>-->
<!--      <v-list-->
<!--        three-line-->
<!--        subheader-->
<!--      >-->
<!--        <v-subheader>General</v-subheader>-->
<!--        <v-list-item>-->
<!--          <v-list-item-action>-->
<!--            <v-checkbox v-model="notifications"></v-checkbox>-->
<!--          </v-list-item-action>-->
<!--          <v-list-item-content>-->
<!--            <v-list-item-title>Notifications</v-list-item-title>-->
<!--            <v-list-item-subtitle>Notify me about updates to apps or games that I downloaded</v-list-item-subtitle>-->
<!--          </v-list-item-content>-->
<!--        </v-list-item>-->
<!--        <v-list-item>-->
<!--          <v-list-item-action>-->
<!--            <v-checkbox v-model="sound"></v-checkbox>-->
<!--          </v-list-item-action>-->
<!--          <v-list-item-content>-->
<!--            <v-list-item-title>Sound</v-list-item-title>-->
<!--            <v-list-item-subtitle>Auto-update apps at any time. Data charges may apply</v-list-item-subtitle>-->
<!--          </v-list-item-content>-->
<!--        </v-list-item>-->
<!--        <v-list-item>-->
<!--          <v-list-item-action>-->
<!--            <v-checkbox v-model="widgets"></v-checkbox>-->
<!--          </v-list-item-action>-->
<!--          <v-list-item-content>-->
<!--            <v-list-item-title>Auto-add widgets</v-list-item-title>-->
<!--            <v-list-item-subtitle>Automatically add home screen widgets</v-list-item-subtitle>-->
<!--          </v-list-item-content>-->
<!--        </v-list-item>-->
<!--      </v-list>-->
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
      }
    },
  }


</script>

<style scoped>

</style>
