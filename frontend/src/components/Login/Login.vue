<template>
  <div class="login-page">
    <div class="login-container">
      <img src="../../assets/global/gotam-logo.png" alt="Gotham City Logo" class="logo" />
      <h1>Login to Gotham</h1>
      <form @submit.prevent="handleSubmit">
        <div class="form-group">
          <label for="email">Email:</label>
          <input type="email" id="email" v-model="email" required />
        </div>
        <div class="form-group">
          <label for="password">Password:</label>
          <input type="password" id="password" v-model="password" required />
        </div>
        <button type="submit" class="image-button">
          <img src="../../assets/global/batman.png" alt="Batman Logo" class="logo" />
        </button>
      </form>
    </div>
  </div>
</template>

<script src="Login.js"></script>
<style src="Login.css"></style>