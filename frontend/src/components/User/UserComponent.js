export default {
  data() {
    return {
      user: {
        firstname: '', // Add these properties as placeholders to avoid errors
        name: '',
        email: '',
        age: null,
        User_logo: null, // Optional: If you want to add a user image dynamically
      },
      searchQuery: '',
      loading: false, // To track loading state
      error: null, // To store error message if the fetch fails
    };
  },
  methods: {
    async fetchUser() {
      this.loading = true;
      this.error = null;
      try {
        const response = await fetch('http://localhost:4000/api/users/1');
        if (!response.ok) {
          throw new Error('Failed to fetch user');
        }
        const data = await response.json();
        this.user = data; // Assign fetched data to user
      } catch (err) {
        this.error = err.message;
      } finally {
        this.loading = false; // Stop loading once fetch is complete
      }
    },
    async searchUser() {
      if (this.searchQuery) {
        this.loading = true;
        this.error = null;
        try {
          const response = await fetch(`http://localhost:4000/api/users?username=${this.searchQuery}`);
          if (!response.ok) {
            throw new Error('Failed to search user');
          }
          const data = await response.json();
          // Map the data returned from the API to the `user` object
          if (data.length > 0) {
            const userData = data[0]; // Use the first user found
            this.user.name = userData.username; // Map the username
            this.user.email = userData.email;   // Map the email
          } else {
            this.user = null; // Clear user data if no user is found
          }
        } catch (err) {
          this.error = err.message;
        } finally {
          this.loading = false;
        }
      }
    },
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