import { ref } from 'vue';

// Define a list of color names (without hexadecimal codes)
export const colors = ref([
  { name: 'Blue' },
  { name: 'Yellow' },
  { name: 'Purple' },
  { name: 'Orange' },
  { name: 'Green' },
  { name: 'Red' }
]);

// Store the selected color from the dropdown
export const selectedColor = ref(colors.value[0]);

// Function to handle the color selection
export const selectColor = (color) => {
  selectedColor.value = color; // Update the selected color
  localStorage.setItem('selectedColor', JSON.stringify(color)); // Save the selected color in localStorage
};

// On app initialization, load the stored color if it exists
const storedColor = localStorage.getItem('selectedColor');
if (storedColor) {
  selectedColor.value = JSON.parse(storedColor);
}
