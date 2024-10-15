<template>
  <div class="selected-colour-info" v-if="color">
    <p>{{ color.name }}</p>
    <div class="circle" :class="color.name.toLowerCase()"></div>
  </div>
</template>

<script setup>
import { defineProps } from 'vue';

const props = defineProps({
  color: {
    type: Object,
    required: true,
  },
});
</script>

<style scoped src="./ColourDisplayer.css"></style>
