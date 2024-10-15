<script setup>
import { ref } from 'vue'; // Import ref to create a reactive reference
import { RouterView } from 'vue-router';
import HeaderComponent from "@/components/Header/Header.vue";
import LoginPage from "@/components/Login/Login.vue";

// Authentication state
const isAuthenticated = ref(false);

// Function to handle successful login
function handleLoginSuccess() {
  isAuthenticated.value = true;
}
</script>

<template>
  <div>
    <LoginPage v-if="!isAuthenticated" @loginSuccess="handleLoginSuccess"/>
    <div v-else>
      <header>
        <HeaderComponent/>
      </header>
      <main class="main-content">
        <div class="background blue"></div>
        <router-view/>
      </main>
    </div>
  </div>
</template>

<style src="./App.css"></style>
