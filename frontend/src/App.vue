<script setup>
import { ref, onMounted } from 'vue';
import { RouterView } from 'vue-router';
import HeaderComponent from "@/components/Header/Header.vue";
import LoginPage from "@/components/Login/Login.vue";
import ColourPicker from "./components/Header/ColourPicker/ColourPicker.vue";

const isAuthenticated = ref(false);
const selectedColorClass = ref('blue'); // Default color class

function handleLoginSuccess() {
  isAuthenticated.value = true;
}

// Function to load the selected color from local storage
function loadSelectedColor() {
  const storedColor = localStorage.getItem('selectedColor');
  if (storedColor) {
    // Assuming stored color is an object with a name property
    const color = JSON.parse(storedColor);
    selectedColorClass.value = color.name.toLowerCase(); // Set the color class
  }
}

onMounted(loadSelectedColor);

const updateColorClass = (event) => {
  selectedColorClass.value = event.detail.name.toLowerCase();
  alert(`Receving in App.vue Color changed to ${event.detail.name}`);
};

window.addEventListener('colorSelected', updateColorClass);
</script>

<template>
  <div>
    <LoginPage v-if="!isAuthenticated" @loginSuccess="handleLoginSuccess"/>
    <div v-else>
      <header>
        <HeaderComponent/>
      </header>
      <main class="main-content">
        <div class="background" :class="[selectedColorClass]"></div>
        <router-view/>
      </main>
    </div>
  </div>
</template>

<style src="./App.css"></style>
