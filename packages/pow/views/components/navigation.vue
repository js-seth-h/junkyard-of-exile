<template>
  <div id="navigation">
<!--    {{list_data}}-->

    <div v-for="(item, key) of list_data" :key="key">
      {{item.item_data.header}}
    </div>
  </div>
</template>

<script>
  export default {
    name: "navigation",
    props:{
      list_data: Array
    },
  }
</script>

<style scoped>

</style>
