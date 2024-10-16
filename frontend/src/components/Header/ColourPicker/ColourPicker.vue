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
      <ColourDisplayer :color="selectedColor" />
    </div>
  </div>
</template>

<script lang="ts" setup>
import ColourDisplayer from './ColourDisplayer/ColourDisplayer.vue';
import { defineEmits, ref } from 'vue';

const selectedColor = ref(null);

const emit = defineEmits(['colorSelected']);

const colors = ref([
  { name: 'Blue' },
  { name: 'Yellow' },
  { name: 'Purple' },
  { name: 'Orange' },
  { name: 'Green' },
  { name: 'Red' }
]);

const selectColor = (color) => {
  selectedColor.value = color; 
  localStorage.setItem('selectedColor', JSON.stringify(color)); 
  emit('colorSelected', color); 
};


</script>

<style scoped src="./ColourPicker.css"></style>
