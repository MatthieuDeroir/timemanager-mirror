<template>
  <div class="text-center">
    <v-menu :location="location">
      <template v-slot:activator="{ props }">
        <v-btn v-bind="props">Colour selector</v-btn>
      </template>

      <v-list class="list-items">
        <v-list-item
          v-for="(color, index) in colors"
          :key="index"
          @click="selectColor(color)"
          class="item"
        >          
          <div class="circle-colour" :style="{ backgroundColor: color.colors[1] }"></div>
        </v-list-item>
      </v-list>
    </v-menu>
  </div>
</template>

<script lang="ts" setup>
import { defineEmits, ref } from 'vue';

const selectedColor = ref(null);

const emit = defineEmits(['colorSelected']);

const colors = ref([
  { name: 'Blue', colors: ['#5ba0ff', '#1a8eff', '#2d7eeb'] },
  { name: 'Yellow', colors: ['#e6a536', '#e6bd1c', '#e18f02'] },
  { name: 'Purple', colors: ['#8461c7', '#4b2aa9', '#5d35b7'] },
  { name: 'Orange', colors: ['#fb7539', '#e47414', '#d16300'] },
  { name: 'Green', colors: ['#429a42', '#48b942', '#139c1c'] },
  { name: 'Red', colors: ['#e43732', '#c32929', '#db5a5a'] }
]);

const location = ref('start');

const selectColor = (color) => {
  selectedColor.value = color; 
  localStorage.setItem('selectedColor', JSON.stringify(color)); 
  emit('colorSelected', color); 
};
</script>

<style scoped src="./ColourPicker.css"></style>
