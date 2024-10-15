<script setup>
import { ref, onMounted } from 'vue';
import { RouterView } from 'vue-router';
import HeaderComponent from "@/components/Header/Header.vue";
import LoginPage from "@/components/Login/Login.vue";

const isAuthenticated = ref(false);
const selectedColorClass = ref('blue'); // Default color class

function handleLoginSuccess() {
  isAuthenticated.value = true;
}

function loadSelectedColor() {
  const storedColor = localStorage.getItem('selectedColor');
  if (storedColor) {
    const color = JSON.parse(storedColor);
    selectedColorClass.value = color.name.toLowerCase(); // Set the color class
  }
}

onMounted(loadSelectedColor);

function updateColorClass(newColor) {
  console.log("New Color Class:", newColor.name.toLowerCase());
  selectedColorClass.value = newColor.name.toLowerCase();
}


</script>

<template>
  <div>
    <LoginPage v-if="!isAuthenticated" @loginSuccess="handleLoginSuccess"/>
    <div v-else>
      <header>
        <HeaderComponent @color-selected="updateColorClass" />
      </header>
      <main class="main-content">
        <div class="background" :class="[selectedColorClass]"></div>
        <router-view/>
      </main>
    </div>
  </div>
</template>

<style src="./App.css"></style>
