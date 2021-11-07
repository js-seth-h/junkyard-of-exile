<template>
  <div id="item">
    this is item
    <br />
    //{{item_data}}//

  </div>
</template>

<script>
  export default {
    name: "item",
    props:{
      item_data: Object,
    },
  }
</script>

<style scoped>

</style>
