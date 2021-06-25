<template>
  <div id="app">
  <!--  lift list area start  -->
    <div class="left">
      <button @click="list_status = !list_status">list {{list_status}}</button>
      <div v-if="list_status === true">
        list
      </div>
      <div v-else>
        input
        <textarea></textarea>
        <button >save btn</button>
      </div>
    </div>

  <!--  lift list area end  -->

  <!--  right area end  -->
    <div class="right">
      <!--  selected data start  -->
      <div class="selected">
        selected data
      </div>
      <!--  selected data start  -->

      <!--  result data start  -->
      <div class="result">
        result data
      </div>
      <!--  result data start  -->
    </div>

    <!--  right area end  -->
  </div>
</template>
<script>

  import axios from "axios"
  export default {
    name: 'App',
    data(){
      return{
        list_status : true
      }
    },
    methods: {
      test(){
      alert(1)
      }

    }

  }
</script>


<style lang="scss">
  .left{
    display: inline-block;
    width: 40%;
    background-color: darkkhaki;
  }

  .right{
    display: inline-block;
    width: 40%;
    background-color: blue;
    .selected{
      width: 100%;
      background-color: violet;
    }
    .result{
      width: 100%;
      background-color: blueviolet;
    }
  }


</style>
