<template>
  <div id="app">
    asdfsadf
    <br />
    <img src="./grapefruit.jpeg" alt="">
    <br />
    <button @click="test">test</button>
  </div>
</template>
<script>

  import axios from "axios"
  export default {
    name: 'App',
    data(){
      return{}
    },
    methods: {
      test(){
        alert(1)
      },
      getLogin() {


        // let POESESSID = "85bfa2d393e324ec7613f45cc8ac48ec"
        let POESESSID = "219467ddde52365dce25a7d0464d32c8"

        let param = {
          client_id: "김귀리",
          response_type: 'code',
          scope: "account:profile",
          state: POESESSID,
          redirect_uri: "http://localhost:1234/",
          prompt: "consent",
          // scope:service:psapi

        }

        // access_token : POESESSID


        axios.post('https://www.pathofexile.com/oauth/authorize', param)
        .then((res) => {
          console.log(res);
        })
        .catch((err) => {
          console.log(err);
        });
      }
    }

  }
</script>


<style lang="scss">
</style>
