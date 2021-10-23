<template>
  <div>
    <div> this is login page</div>
    <button @click="login">login btn</button>
  </div>
</template>

<script>
  export default {
    name: "Login",
    methods: {
      login(){
        this.$router.push({ path:'main' });
      }
    }
  }
</script>

<style scoped>

</style>
