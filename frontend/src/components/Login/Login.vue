<template>
  <div class="background blue"></div>
  <div class="login-wrapper">
    <div class="login-page">
      <div class="login-container">
        <img alt="Gotham City Logo" class="logo" src="../../assets/global/gotam-logo.png" />
        <h1>Login to Gotham</h1>
        <form @submit.prevent="handleSubmit" method="post">
          <div class="form-group">
            <label for="email">Email:</label>
            <input
              id="email"
              v-model="email"
              class="textcenter"
              placeholder="Your email here"
              required
              type="email"
            />
          </div>
          <div class="form-group">
            <label for="password">Password:</label>
            <input
              id="password"
              v-model="password"
              class="textcenter"
              placeholder="Your password here"
              required
              type="password"
            />
          </div>
          <div class="white-circle">
            <button class="image-button" type="submit" @click="handleSubmit" @touchstart="handleSubmit">
              <img alt="Batman Logo" class="logo" src="../../assets/global/batman.png" />
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { ref } from 'vue'
import { useAuth } from '@/composables/useAuth'

const email = ref('')
const password = ref('')

const { login } = useAuth()

const handleSubmit = async (event) => {
  event.preventDefault();
  alert('Button clicked');  // Check if the event is firing on click
  console.log('Email:', email.value, 'Password:', password.value);  // Debugging logs
  await login({ email: email.value, password: password.value });
};

document.addEventListener('deviceready', () => {
  alert('Device is ready, app can handle interactions.');
  // Now your login logic should work properly after Cordova is ready
});


</script>

<style src="./Login.css"></style>