<template>
  <header class="header">
    <h1>GOTHAM Time Manager</h1>
    <img src="../../assets/global/batman.png" alt="Gotham Logo" class="navbar-logo">
    <div>
      <v-menu open-on-hover>
        <template v-slot:activator="{ props }">
          <v-btn
              color="primary"
              v-bind="props"
          >
            Duckler McQuack
          </v-btn>
        </template>
        <v-list>
          <v-list-item
              v-for="(item, index) in items"
              :key="index"
          >
            <v-list-item-title>{{ item.title }}</v-list-item-title>
          </v-list-item>
        </v-list>
      </v-menu>
    </div>
  </header>
</template>

<script src="./Header.js"></script>
<style src="./Header.css"></style>