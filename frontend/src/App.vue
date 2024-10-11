<script setup>
import { RouterView } from 'vue-router'

</script>

<template>
   <header>
      <!-- The router-view will render the component matched by the route -->
      <router-view />
      <Calendar />
      <UserComponent/>
  </header>
</template>



<style scoped>

</style>
