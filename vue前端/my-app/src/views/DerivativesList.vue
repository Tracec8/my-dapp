<template>
    <div class="derivatives-list">
      <h2>所有创建过的金融衍生品合约</h2>
      <ul>
        <li v-for="derivative in derivatives" :key="derivative.id">
          合约ID: {{ derivative.id }} - 买方地址: {{ derivative.buyer }} - 价格: {{ derivative.price }} {{ derivative.priceUnit }} - 到期时间: {{ derivative.expiration }}
        </li>
      </ul>
    </div>
  </template>
  
  <script>
  export default {
    props: ['derivatives'],
  };
  </script>
  
  <style>
  /* 样式 */
  </style>
  