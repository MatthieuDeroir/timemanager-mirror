<template>
  <div>
    <header v-if="!shouldHideNavbar">
      <HeaderComponent @colorSelected="updateColorClass" />
    </header>
    <main class="main-content">
      <div :class="[selectedColorClass]" class="background"></div>
      <!-- <v-btn style="margin-top: 100px;" @click="toggleTheme">toggle theme</v-btn>   -->
      <router-view />
    </main>
  </div>
</template>

<style src="./App.css"></style>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { RouterView, useRoute } from 'vue-router'
import HeaderComponent from '@/components/Header/Header.vue'

import { useTheme } from 'vuetify'

const theme = useTheme()

function toggleTheme() {
  const darkModeQuery = window.matchMedia('(prefers-color-scheme: dark)')

  const change = () => {
    if (darkModeQuery.matches) {
      theme.global.name.value = 'myCustomDarkTheme'
    } else {
      theme.global.name.value = 'myCustomLightTheme'
    }
  }
  darkModeQuery.addEventListener('change', change)
  change()
}

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

toggleTheme()

const shouldHideNavbar = computed(() => route.meta.hideNavbar)
</script>
