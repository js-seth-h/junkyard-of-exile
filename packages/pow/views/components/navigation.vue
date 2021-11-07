<template>
  <div id="navigation">
<!--    {{list_data}}-->

    <div v-for="(con, key) of list_data" :key="key">

      {{list_data[key].block_order}}
      <div v-for="(data, key_data) of list_data" :key="key_data">

        con-> {{data}}
        <br />
        key-> {{key_data}}
        <br />
      </div>
<!--      -->
<!--      con-> {{con}}-->
<!--      <br />-->
<!--      key-> {{key}}-->
<!--      <br />-->
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
