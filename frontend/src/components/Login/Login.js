import { ref } from 'vue';

// State for authentication
export const isAuthenticated = ref(false);
const test=true;

// Function to handle login
export const handleLogin = (email, password) => {
  // Replace with your actual authentication logic
  //email === 'test@example.com' && password === 'password'

  if (test) {
    isAuthenticated.value = true; // Set to true on successful login
    localStorage.setItem('isAuthenticated', true); // Store authentication status
    return true; // Indicate login success
  }
  return false; // Indicate login failure
};
