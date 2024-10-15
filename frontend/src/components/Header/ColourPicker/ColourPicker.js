import { ref } from 'vue';

export const colors = ref([
  { name: 'Blue' },
  { name: 'Yellow' },
  { name: 'Purple' },
  { name: 'Orange' },
  { name: 'Green' },
  { name: 'Red' }
]);

export const selectedColor = ref(null);

export const selectColor = (color) => {
  selectedColor.value = color; 
  localStorage.setItem('selectedColor', JSON.stringify(color)); 
};

const storedColor = localStorage.getItem('selectedColor');
if (storedColor) {
  selectedColor.value = JSON.parse(storedColor);
}


