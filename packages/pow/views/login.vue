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

  let clientId = 'GNLVthqCf49GAa9jaDbGZioqk3xvz0QoAcPkWKR3WbI5087O1Um68INjPTLVd5kQ'
  let redirect = 'http://wiki.cmgom.com:5000/patreon/redirect'
  let qs = require('qs')
  let url = "https://patreon.com/oauth2/authorize?" + qs.stringify({
    response_type: 'code',
    client_id: clientId,
    redirect_uri: redirect,
    state: 'chill'
  })


  import ws from "pow/ws"

  export default {
    name: "Login",
    methods: {

      goto_content(){
        this.$router.push({ path:'main' });
      },

      login(){
        // ws = require('pow/ws')
        ws.openUrl(url)
        // this.$router.push({ path:'main' });
      }
    }
  }
</script>

<style scoped>

</style>
