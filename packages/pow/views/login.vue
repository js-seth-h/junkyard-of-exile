<template>
  <div>
    <div> this is login page</div>
    <button @click="login">goto login</button>
    <br />
    <a
      href="https://patreon.com/oauth2/authorize?response_type=code&amp;client_id=GNLVthqCf49GAa9jaDbGZioqk3xvz0QoAcPkWKR3WbI5087O1Um68INjPTLVd5kQ&amp;redirect_uri=http%3A%2F%2Flocalhost%3A5000%2Fpatreon%2Fredirect&amp;state=chill">Login
      with Patreon</a>
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
