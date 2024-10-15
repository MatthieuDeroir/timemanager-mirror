<template>
  <div class="background blue"></div>
  <div class="login-wrapper">
    <div class="login-page"> 
      <div class="login-container">
        <img src="../../assets/global/gotam-logo.png" alt="Gotham City Logo" class="logo" />
        <h1>Login to Gotham</h1>
        <form @submit.prevent="handleSubmit">
          <div class="form-group">
            <label for="email">Email:</label>
            <input type="email" id="email" v-model="email" required placeholder="Your email here" class="textcenter"/>
          </div>
          <div class="form-group">
            <label for="password">Password:</label>
            <input type="password" id="password" v-model="password" required placeholder="Your password here" class="textcenter"/>
          </div>
          <div class="white-circle">
            <button type="submit" class="image-button">
              <img src="../../assets/global/batman.png" alt="Batman Logo" class="logo" />
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { handleLogin } from './Login.js'; // Adjust the path as necessary
import { defineEmits } from 'vue';

// Emit event for successful login
const emit = defineEmits(['loginSuccess']);

// Reactive variables for email and password
const email = ref('');
const password = ref('');

// Function to handle the form submission
const handleSubmit = () => {
  if (handleLogin(email.value, password.value)) {
    emit('loginSuccess'); // Emit the event if login is successful
  } else {
    alert('Login failed. Please check your credentials.'); // Handle failed login
  }
};
</script>

<style src="./Login.css"></style>
