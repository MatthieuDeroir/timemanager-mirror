<template>
  <div class="text-center">
    <v-menu>
      <template v-slot:activator="{ props }">
        <v-btn v-bind="props">Color Options</v-btn>
      </template>

      <v-list>
        <v-list-item
          v-for="(color, index) in colors"
          :key="index"
          @click="selectColor(color)"
        >
          <v-list-item-title>{{ color.name }}</v-list-item-title>
        </v-list-item>
      </v-list>
    </v-menu>

    <div class="selected-colour-info" v-if="selectedColor">
      <p>{{ selectedColor.name }}</p>
    </div>
    <ColourDisplayer v-if="selectedColor" :color="selectedColor"/>
  </div>
</template>

<script lang="ts" setup>
import { colors, selectedColor, selectColor } from './ColourPicker.js';
import ColourDisplayer from './ColourDisplayer/ColourDisplayer.vue';
import { defineEmits } from 'vue';

const emit = defineEmits(['colorSelected']);

const selectColor = (color) => {
  selectedColor.value = color; 
  localStorage.setItem('selectedColor', JSON.stringify(color)); 
  emit('colorSelected', color); 
};
</script>

<style scoped src="./ColourPicker.css"></style>
