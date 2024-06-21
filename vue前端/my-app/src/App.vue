<template>
  <div id="app">
    <router-view></router-view>
  </div>
</template>

<script>
import router from './router';


export default {
    name: 'App',
    components: { router }
}
</script>
<style lang="less">
  html,body,h3 {
    margin: 0;
    padding: 0
  }
</style>