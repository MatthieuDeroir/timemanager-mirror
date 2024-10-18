<script setup>
import { computed, onMounted, ref } from 'vue'
import { RouterView, useRoute } from 'vue-router'
import HeaderComponent from '@/components/Header/Header.vue'

const route = useRoute()
const selectedColorClass = ref('blue')

function loadSelectedColor() {
  const storedColor = localStorage.getItem('selectedColor')
  if (storedColor) {
    const color = JSON.parse(storedColor)
    selectedColorClass.value = color.name.toLowerCase()
  }
}

onMounted(loadSelectedColor)

function updateColorClass(color) {
  selectedColorClass.value = color.name.toLowerCase()
}

const shouldHideNavbar = computed(() => route.meta.hideNavbar)
</script>

<template>
  <div>
    <header v-if="!shouldHideNavbar">
      <HeaderComponent @colorSelected="updateColorClass" />
    </header>
    <main class="main-content">
      <div :class="[selectedColorClass]" class="background"></div>
      <router-view />
    </main>
  </div>
</template>

<style src="./App.css"></style>