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
          class="item"
          @click="selectColor(color)"
        >
          <div
            :style="{ background: 'var(--linear-' + color.name + ')' }"
            class="circle-colour"
          ></div>
        </v-list-item>
      </v-list>
    </v-menu>
  </div>
</template>
<!-- color.colors[1] -->
<script lang="ts" setup>
import { defineEmits, ref } from 'vue'

const selectedColor = ref(null)

const emit = defineEmits(['colorSelected'])

const colors = ref([
  { name: 'blue' },
  { name: 'yellow' },
  { name: 'purple' },
  { name: 'orange' },
  { name: 'green' },
  { name: 'red' }
])

const location = ref('start')

const selectColor = (color) => {
  selectedColor.value = color
  localStorage.setItem('selectedColor', JSON.stringify(color))
  emit('colorSelected', color)
}
</script>

<style scoped src="./ColourPicker.css"></style>
