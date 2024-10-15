<template>
  <div class="text-center">
    <!-- Dropdown button to trigger the menu with color-related options -->
    <v-menu>
      <template v-slot:activator="{ props }">
        <v-btn v-bind="props">
          Color Options
        </v-btn>
      </template>

      <v-list>
        <!-- Displaying a list of color options -->
        <v-list-item
          v-for="(color, index) in colors"
          :key="index"
          @click="selectColor(color)"
        >
          <v-list-item-title>{{ color.name }}</v-list-item-title>
        </v-list-item>
      </v-list>
    </v-menu>

    <!-- Display the selected color information -->
    <div class="selected-color-info">
      <p>{{ selectedColor.name }}</p>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { colors, selectedColor, selectColor } from './ColorPicker.js';
</script>

<style scoped src="./ColorPicker.css"></style>
