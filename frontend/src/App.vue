<script setup>
import { RouterLink, RouterView } from 'vue-router';
import UserComponent from './components/User/UserComponent.vue';


const user = {
  name: 'Duckler Quackity',
  email: 'Duckler_Quackity@farmbirds.com',
  age: '3 moons since hatching',
  address: '123 Feather Nest, Pondview Lane',
  zipcode: 'QCK-1234'
};

</script>

<template>
  <header>

    <div class="wrapper">

      <nav>
        <RouterLink to="/">Home</RouterLink>
        <RouterLink to="/about">About</RouterLink>
      </nav>
    </div>

  </header>
  <UserComponent :user="user" />
  
</template>

<style scoped>
</style>
