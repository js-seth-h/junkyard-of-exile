<template>
  <div id="item" class="item">
    <div class="img">this is image
    </div>

    <div class="content">
      <div v-for="(order_data, order_key) of item_data.block_order" :key="order_key">
        <div :class="order_data+'_wrap'"
             class="order_group"
          v-if="order_data === item_group_key"
          v-for="(item_group, item_group_key) of item_data" :key="item_group_key">

          <!-- title start-->
          <div class="title" v-if="order_data === 'header'" >
            <p>{{item_group.lines[2]}}</p>
            <p>{{item_group.lines[3]}}</p>
          </div>

          <!-- other start (not header) -->
          <div :class="order_data+'_con'"
               class="item_lines_con"
               v-for="(item_data, item_data_key) of item_group.lines"
               v-if="order_data !== 'header'">
              {{item_data}}
          </div>
          <!-- implicit_mods, implicit_mods start -->
          <div :class="order_data+'_con'"
               class="item_mods_con"
               v-for="(item_data, item_data_key) of item_group.mods"
               :key="item_data_key">
            {{item_data.str}}
          </div>
        </div>
        <span v-if="order_data !== 'header' && item_data.block_order[item_data.block_order.length-1] !== order_data" :class="order_data+'_separator'" class="separator"></span>

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
