export default {
  data() {
    return {
      user: {
        username: '',
        email: '',
      },
      searchQuery: '',
      suggestions: [],
      loading: false,
      error: null,
    };
  },
  methods: {
    async handleSearchInput() {
      if (this.searchQuery.length >= 1) {
        try {
          const response = await fetch(`http://localhost:4000/api/users?username=${this.searchQuery}`);
          if (!response.ok) {
            throw new Error('Failed to search user');
          }
          const data = await response.json();
          this.suggestions = data
        } catch (err) {
          this.error = err.message;
        }
      } else {
        this.suggestions = [];
      }
    },

    async selectUser(suggestion) {
      this.searchQuery = suggestion.username;
      this.suggestions = [];

      try {
        const response = await fetch(`http://localhost:4000/api/users/${suggestion.id}`);
        if (!response.ok) {
          throw new Error('Failed to fetch user');
        }
        const data = await response.json();
        this.user = data; 
      } catch (err) {
        this.error = err.message;
      }
    },

    hideSuggestions() {
      setTimeout(() => {
        this.suggestions = [];
      }, 200);
    },

    async createUser() {
        try {
            const userData = {
            user: {
                email: this.user.email,
                username: this.user.username,
            },
            };

            const response = await fetch('http://localhost:4000/api/users', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(userData),
            });

            if (!response.ok) {
            throw new Error('Failed to create user');
            }

            const createdUser = await response.json();

            this.user = {
            id: createdUser.id,     
            username: createdUser.username,
            email: createdUser.email,
            };

            alert('User created successfully! Now you can edit the user.');

        } catch (err) {
            console.error('Error creating user:', err);
            alert(`Error creating user: ${err.message}`);
        }
    },


   async updateUser() {
      try {
        if (!this.user.id) {
          alert('User ID is required to update the user.');
          return;
        }

        const userData = {
          user: {
            email: this.user.email,
            username: this.user.username,
          },
        };

        const response = await fetch(`http://localhost:4000/api/users/${this.user.id}`, {
          method: 'PUT',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify(userData), 
        });

        if (!response.ok) {
          throw new Error('Failed to update user');
        }

        const updatedUser = await response.json();

        this.user = {
          id: updatedUser.id,         
          username: updatedUser.username,
          email: updatedUser.email,
        };

        alert('User updated successfully!');

      } catch (err) {
        console.error('Error updating user:', err);
        alert(`Error updating user: ${err.message}`);
      }
    },
    async deleteUser() {
      try {
        if (!this.user.id) {
          alert('User ID is required to delete the user.');
          return;
        }

        const response = await fetch(`http://localhost:4000/api/users/${this.user.id}`, {
          method: 'DELETE',
        });

        if (!response.ok) {
          throw new Error('Failed to delete user');
        }

        alert('User deleted successfully!');

        this.user = {
          id: null,
          username: '',
          email: '',
        };

      } catch (err) {
        console.error('Error deleting user:', err);
        alert(`Error deleting user: ${err.message}`);
      }
    },
  },
};