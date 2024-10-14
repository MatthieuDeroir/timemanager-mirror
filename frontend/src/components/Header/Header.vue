<template>
  <header class="header">
    <img alt="Gotham Logo" class="navbar-logo" src="@/assets/global/batman.png"/>
    <h1>GOTHAM Time Manager</h1>
    <UserSearch @user-selected="handleUserSelected"/>
    <div>
      <v-menu open-on-hover>
        <template v-slot:activator="{ props }">
          <v-btn color="primary" v-bind="props"> Duckler McQuack</v-btn>
        </template>
        <v-list>
          <!-- Boucle pour afficher les options du menu -->
          <v-list-item v-for="(item, index) in items" :key="index">
            <v-list-item-title>{{ item.title }}</v-list-item-title>
          </v-list-item>
        </v-list>
      </v-menu>
    </div>
  </header>
</template>

<script lang="ts" setup>
import UserSearch from "@components/user/UserSearch/UserSearch.vue";
import {ref} from 'vue';

const items = [
  {title: 'Profil'},
  {title: 'Log out'},
];

const selectedUserId = ref<number | null>(null);

const handleUserSelected = (userId: number) => {
  selectedUserId.value = userId;
};
</script>

<style scoped src="./Header.css"></style>
