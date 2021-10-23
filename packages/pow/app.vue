<template>
  <div class="app">
<!--    <button @click="main">main btn</button>-->
    <router-link to="/"></router-link>
    <router-view />
  </div>
</template>


<script>
  import './assets/css/normalize.css';
  import './assets/css/common.css';
  export default {
    name: 'App',
    components: {
    },
    methods: {
      main(){
        this.$router.push({ path:'/' });
      }
    }
  }
</script>

<style lang="scss">
</style>
