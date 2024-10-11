<script setup>
import TheWelcome from '../components/TheWelcome.vue'
import HeaderComponent from './components/Header/HeaderComponent.vue';
import Calendar from './components/Calendar.vue';
import UserComponent from './components/User/UserComponent.vue';

  const isAuthenticated = ref(false); 

  function handleLoginSuccess() {
    isAuthenticated.value = true;
  }
</script>

<template>
     <div v-if="!isAuthenticated">
      <LoginPage @login-success="handleLoginSuccess" />
    </div>

    <div v-else>
      <header>
        <HeaderComponent />
      </header>
      <main>
        <div class="wrapper">
          <router-view />
          <Calendar />
          <UserComponent />
        </div>  
      </main>
    </div>
</template>
