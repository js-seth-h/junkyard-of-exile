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


  import ws from "pow/ws"
  import BEC from "pow/backend-connection"

  export default {
    name: "Login",
    methods: {

      goto_content(){
        this.$router.push({ path:'main' });
      },

      async login(){
        // ws = require('pow/ws')
        // let url = BEC.getPatreonOauthUrl()
        ws.openPatronOauth()

        ws.evalItem({ test: true})
        // this.$router.push({ path:'main' });
      }
    }
  }
</script>

<style scoped>

</style>
