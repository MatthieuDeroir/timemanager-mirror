<template>
  <div class="user-component">
    <div v-if="loading">
      <p>Loading user data...</p>
    </div>

    <div v-if="error">
      <p>Error: {{ error }}</p>
    </div>

    <div v-if="!loading">
      <div class="image-container">
        <img v-if="user.User_logo" :src="user.User_logo" alt="User Image" class="user-image" />
      </div>
      <div>
        <input
          type="text"
          v-model="searchQuery"
          placeholder="Search by username"
          @input="handleSearchInput"
          @blur="hideSuggestions"
          class="autocomplete-input"
          
        />

        <ul v-if="suggestions.length > 0" class="autocomplete-suggestions">
          <li v-for="suggestion in suggestions" :key="suggestion.id" @mousedown.prevent="selectUser(suggestion)">
            {{ suggestion.username }}
          </li>
        </ul>
        
        <div v-if="user && user.username" class="username-display">
          <h2>{{ user.username }}</h2>
          <div>
            <button type="button" @click="clearUser" class="clear-btn">Clear user</button>
          </div>
        </div>
      </div>

      <form @submit.prevent="submitForm">
        <!-- <div class="table-container">
          <label for="id" class="left-space">User ID:</label>
          <span class="left-space">{{ user.id }}</span>
        </div> -->
        <div class="table-container">
          <label for="name" class="left-space">User Name:</label>
          <input type="text" id="username" v-model="user.username" class="right-space" />
        </div>
        <div class="table-container">
          <label for="email" class="left-space">Email:</label>
          <input type="email" id="email" v-model="user.email" class="right-space" />
        </div>
        <div class="button-group">
          <button type="button" @click="createUser" class="Create-btn">Create User</button>
          <button type="button" @click="updateUser" class="Update-btn">Update User</button>
          <button type="button" @click="deleteUser" class="Delete-btn">Delete User</button>
        </div>
      </form>
    </div>
  </div>
</template>


<style src="./UserComponent.css"></style>
<script src="./UserComponent.js"></script>
