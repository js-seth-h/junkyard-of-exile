<template>
  <div>
    <v-container fluid>
      <v-row>
<!--        <v-col cols="4" md="4">-->
<!--          <v-textarea-->
<!--            no-resize-->


<!--            name="input-7-1"-->
<!--            label="Default style"-->
<!--            value="The Woodman set to work at once, and so sharp was his axe that the tree was soon chopped nearly through."-->
<!--            hint="Hint text"-->
<!--          ></v-textarea>-->
<!--        </v-col>-->
<!--      </v-row>-->

<!--      <v-col cols="8" md="8">-->
<!--        test-->
<!--      </v-col>-->

        <v-col cols="12" md="4">
          <v-textarea
            no-resize
            name="input-7-1"
            label="Default style"
            value="The Woodman set to work at once, and so sharp was his axe that the tree was soon chopped nearly through."
            hint="Hint text"
          ></v-textarea>
        </v-col>
        <v-col cols="12" md="8">
          <v-textarea
            solo
            name="input-7-4"
            label="Solo textarea"
          ></v-textarea>
        </v-col>

    </v-container>
  </div>
</template>
<script>

  import axios from "axios"
  export default {
    name: 'App',
    data(){
      return{
        list_status : false
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

</style>
