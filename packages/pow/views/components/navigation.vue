<template>
  <div id="navigation">
  <v-app>
<!--    {{list_data}}-->

    <div v-for="(item, key) of list_data" :key="key">
      <v-tooltip right>
        <template v-slot:activator="{ on, attrs }">
          <v-btn
              dark
              v-bind="attrs"
              v-on="on"
              class="nav_con"
              @click="emit_id(item.id)">
            {{item.item_data.header.lines[2]}} {{item.item_data.header.lines[3]}}
          </v-btn>
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
  export default {
    name: "navigation",
    props:{
      list_data: Array
    },
    components: {Item},
    methods: {
      emit_id(id){
        console.log('111111111111111111111111111', id)
        this.$emit("emited_id", id)
      }
    }
  }
</script>

<style scoped>

</style>
