<template>
  <div id="login" class="wrap">
    <button style="color: #fff;" @click="goto_content">go to contnet</button>
    <div class="con">
      <p class="title">Junkyard of Exile</p>
      <p class="sub_title">please login with patreon</p>
      <button class="login_btn" @click="login">Login with Patreon</button>


    </div>


  </div>
</template>

<script>
  import bridge from 'exterra/bridge'
  import J from 'jsl'

  import '../assets/css/login.css';
  export default {
    name: "Login",
    async mounted() {
      // await J.waitOnce(ws, 'app-ready')

    },
    methods: {
      goto_content(){
        this.$router.push({ path:'main' });
      },

      async login(){
        bridge.emit('patreon-oauth')
        await J.waitOnce(bridge, 'oauth-login-ok')
        alert('ok')
       }
    }
  }
</script>

<style scoped>

</style>
