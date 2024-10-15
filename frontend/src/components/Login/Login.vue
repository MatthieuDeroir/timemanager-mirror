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

<script src="./Login.js"></script>
<style src="./Login.css"></style>