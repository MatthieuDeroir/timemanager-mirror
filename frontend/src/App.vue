<script setup>
import {RouterView} from 'vue-router'
import HeaderComponent from "@components/Header/Header.vue";
</script>

<template>
  <header>
    <HeaderComponent/>
  </header>
  <main class="main-content">
    <div class="background blue"></div>
    <router-view/>
  </main>
</template>


<style src="./App.css"></style>
