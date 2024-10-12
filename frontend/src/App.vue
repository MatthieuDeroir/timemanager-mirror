<script setup>
import {RouterView} from 'vue-router'
import HeaderComponent from "@/components/Header/HeaderComponent.vue";

</script>

<template>
  <header>
    <HeaderComponent/>
    <router-view/>
  </header>
</template>


<style scoped>
</style>
