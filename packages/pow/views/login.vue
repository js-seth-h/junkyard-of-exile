<template>
  <div>
    <div> this is login page</div>
    <button @click="goto_content">go to contnet</button>
    <br />
    <button @click="login">Login with Patreon</button>
    <br />
    <!-- <a
      href="https://patreon.com/oauth2/authorize?response_type=code&amp;client_id=GNLVthqCf49GAa9jaDbGZioqk3xvz0QoAcPkWKR3WbI5087O1Um68INjPTLVd5kQ&amp;redirect_uri=http%3A%2F%2Flocalhost%3A5000%2Fpatreon%2Fredirect&amp;state=chill">Login
      with Patreon</a> -->

  </div>
</template>

<script>
  import bridge from 'exterra/bridge'
  import J from 'jsl'
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
