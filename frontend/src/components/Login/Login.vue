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
  await login({ email: email.value, password: password.value });
};

</script>

<style src="./Login.css"></style>