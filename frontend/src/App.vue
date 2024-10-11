<script setup>
import { RouterLink, RouterView } from 'vue-router'
import Calendar from './components/Calendar.vue'
import HelloWorld from './components/HelloWorld.vue'
import UserComponent from './components/User/UserComponent.vue';
import HeaderComponent from './components/Header/HeaderComponent.vue';
</script>

<template>
   <header>
    <!-- <img alt="Vue logo" class="logo" src="@/assets/logo.svg" width="125" height="125" /> -->
    <HeaderComponent />
    <div class="wrapper">
      <!-- The router-view will render the component matched by the route -->
      <router-view />
      <Calendar />
      <UserComponent/>
  </header>
</template>



<style scoped>

</style>
