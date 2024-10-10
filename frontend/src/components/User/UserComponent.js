export default {
  data() {
    return {
      user: {
        firstname: '', // Placeholder properties to avoid errors
        name: '',
        email: '',
        age: null,
        User_logo: null, // Optional for a user image
      },
      searchQuery: '',
      suggestions: [], // Holds the autocomplete suggestions
      loading: false, // To track loading state
      error: null, // To store error message if the fetch fails
    };
  },
  methods: {
    // Handle user input for searching users
    async handleSearchInput() {
      // Trigger autocomplete as soon as the user types the first letter
      if (this.searchQuery.length >= 1) {
        try {
          // Make an API call to fetch users by username
          const response = await fetch(`http://localhost:4000/api/users?username=${this.searchQuery}`);
          if (!response.ok) {
            throw new Error('Failed to search user');
          }
          const data = await response.json();
          this.suggestions = data; // Assign matching usernames to suggestions
        } catch (err) {
          this.error = err.message;
        }
      } else {
        // Clear suggestions if input is less than 1 character
        this.suggestions = [];
      }
    },

    // User clicks on a suggestion to fill in the form
    async selectUser(suggestion) {
      this.searchQuery = suggestion.username; // Set the search input to the selected username
      this.suggestions = []; // Clear the suggestions list

      try {
        // Fetch the full user details by ID
        const response = await fetch(`http://localhost:4000/api/users/${suggestion.id}`);
        if (!response.ok) {
          throw new Error('Failed to fetch user');
        }
        const data = await response.json();
        this.user = data; // Populate form fields with fetched user data
      } catch (err) {
        this.error = err.message;
      }
    },

    // Hide autocomplete suggestions when input loses focus
    hideSuggestions() {
      setTimeout(() => {
        this.suggestions = []; // Clear suggestions after a slight delay to allow selection
      }, 200);
    },

    // Create, Update, Delete methods (as before)
    createUser() {
      alert(`Creating user with the following data:\n
        First Name: ${this.user.firstname}\n
        Last Name: ${this.user.name}\n
        Email: ${this.user.email}\n
        Age: ${this.user.age}`);
    },
    updateUser() {
      alert(`Updating user with the following data:\n
        First Name: ${this.user.firstname}\n
        Last Name: ${this.user.name}\n
        Email: ${this.user.email}\n
        Age: ${this.user.age}`);
    },
    deleteUser() {
      alert(`Deleting user with the following data:\n
        First Name: ${this.user.firstname}\n
        Last Name: ${this.user.name}`);
    },
  },
};