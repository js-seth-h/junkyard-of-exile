<template>
  <div class="item_result" id="item_result" style="color: #fff">
    this is item
    <br />
    //{{item_result}}//

  </div>
</template>

<script>
  export default {
    name: "item_result",
    props:{
      item_result: Object,
    },
  }
</script>

<style scoped>

</style>
