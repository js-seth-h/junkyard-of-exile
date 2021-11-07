<template>
  <div id="item">
    <div class="img">
      <div style="width: 100px; height: 100px; background-color: gray;">this is image</div>
    </div>
    <div class="content">
<!--      {{item_data}}-->
      <div v-for="(order_data, order_key) of item_data.block_order" :key="order_key">
       {{order_data}}
        <div v-if="order_data === 'implicit_mods'">
        </div>
        <div v-for="(item_group, item_group_key) of item_data" :key="item_group_key">
          <div v-if="order_data === item_group_key">

            <div v-for="(item_data, item_data_key) of item_group.lines" :key="item_data_key">
              {{item_data}}

            </div>
            <div v-for="(item_data, item_data_key) of item_group.mods" :key="item_data_key">
              {{item_data.str}}
            </div>
          </div>
        </div>

        <span v-if="item_data.block_order[item_data.block_order.length-1] !== order_data" :class="order_data+'_separator'" class="separator"></span>

      </div>

    </div>

  </div>
</template>

<script>
  export default {
    name: "item",
    props:{
      item_data: Object,
    },
  }
</script>

<style scoped>

</style>
