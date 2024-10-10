<template>
  <div class="user-component">
    <div v-if="loading">
      <p>Loading user data...</p>
    </div>

    <div v-if="error">
      <p>Error: {{ error }}</p>
    </div>

    <div v-if="user && !loading">
      <div class="image-container">
        <img :src="user.User_logo" alt="User Image" class="user-image" />
      </div>
      <div>
        <input type="text" v-model="searchQuery" placeholder="Search by username" @input="searchUser" />
        <div>
          <h2>{{ user.name }}</h2>
          <h3>{{ user.firstname }}</h3>
        </div>
      </div>

      <form @submit.prevent="submitForm">
        <div class="table-container">
          <label for="firstname" class="left-space">First Name:</label>
          <input type="text" id="firstname" v-model="user.firstname" class="right-space" />
        </div>
        <div class="table-container">
          <label for="name" class="left-space">Last Name:</label>
          <input type="text" id="name" v-model="user.name" class="right-space" />
        </div>
        <div class="table-container">
          <label for="email" class="left-space">Email:</label>
          <input type="email" id="email" v-model="user.email" class="right-space" />
        </div>
        <div class="table-container">
          <label for="age" class="left-space">Age:</label>
          <input type="number" id="age" v-model="user.age" class="right-space" />
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
