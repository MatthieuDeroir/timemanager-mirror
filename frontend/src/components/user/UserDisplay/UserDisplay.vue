<template>
  <v-card class="mx-auto" max-width="400" outlined>
    <v-card-title>
      <v-avatar class="mr-3" size="50" v-if="user.User_logo">
        <v-img :src="user.User_logo" />
      </v-avatar>
      <div>
        <h3>{{ user.username }}</h3>
        <p class="subtitle-1">{{ user.email }}</p>
      </div>
    </v-card-title>

    <v-divider></v-divider>

      <v-list dense>
        <v-list-item>
          <v-list-item-icon>
            <v-icon color="primary">mdi-account</v-icon>
          </v-list-item-icon>
          <v-list-item-content>
            <v-list-item-title>{{ user.firstName }} {{ user.lastName }}</v-list-item-title>
          </v-list-item-content>
        </v-list-item>

        <v-list-item>
          <v-list-item-content>
            <v-list-item-title>{{ user.username }}</v-list-item-title>
            <v-list-item-title>{{ user.email }}</v-list-item-title>
            <v-list-item-title>{{ user.inserted_at }}</v-list-item-title>
            <v-list-item-title>{{ user.updated_at }}</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list>

    <v-divider></v-divider>

    <v-card-actions>
      <v-btn color="primary" text @click="editUser">Edit</v-btn>
      <v-btn color="error" text @click="deleteUser">Delete</v-btn>
    </v-card-actions>
  </v-card>
</template>

<script setup>
import {onMounted, ref, watch} from 'vue';
import {getUserById} from '@services/userServices.js';

const props = defineProps({
  userId: {
    type: Number,
    required: true,
  }
});

const user = ref({});

const fetchUser = async (userId) => {
  user.value = await getUserById(userId);
};

onMounted(() => fetchUser(props.userId));

watch(() => props.userId, (newUserId) => {
  fetchUser(newUserId);
});

const editUser = () => {
  console.log('Modifier l’utilisateur');
};

const deleteUser = () => {
  console.log('Supprimer l’utilisateur');
};
</script>

