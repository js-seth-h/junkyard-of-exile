<template>
  <div class="app">
    test1
    <router-link to="/"></router-link>
    <router-view />
  </div>
</template>


<script> 
  require('./ws')
  export default {
    name: 'App',
    components: {
    }
  }
</script>

<style lang="scss">
</style>
