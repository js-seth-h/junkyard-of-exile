<template>
  <div id="navigation">
<!--    {{list_data}}-->

    <div v-for="(item, key) of list_data" :key="key">
      <button @click="emit_id(item.item_id)">{{item.item_data.header.lines[2]}} {{item.item_data.header.lines[3]}}</button>
    </div>
  </div>
</template>

<script>
  export default {
    name: "navigation",
    props:{
      list_data: Array
    },
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
