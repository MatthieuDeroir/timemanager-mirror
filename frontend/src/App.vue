<script setup>
import { RouterLink, RouterView } from 'vue-router';
import UserComponent from './components/User/UserComponent.vue';
</script>

<template>
  <header>
    <div class="wrapper">
      <nav>
        <!-- <RouterLink to="/">Home</RouterLink>
        <RouterLink to="/about">About</RouterLink> -->
      </nav>
    </div>
  </header>

  <UserComponent />
</template>

<style scoped>
</style>
