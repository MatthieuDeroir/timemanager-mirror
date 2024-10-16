<template>
      <div>
        <p class="subtitle-1">{{ user.email }}</p>
      </div>

        <!-- {{ user.firstName }} {{ user.lastName }}
            {{ user.email }}
            {{ user.username }}
            {{ user.inserted_at }}
            {{ user.updated_at }} -->
</template>

<script setup>
import {onMounted, ref, watch} from 'vue';
import {getUserById} from '@services/userServices.js';

const props = defineProps( {
  userId: {
    type: Number,
    required: true,
  }
});

const user = ref({});
const emit = defineEmits(['selecteduser']);
const fetchUser = async (userId) => {
  user.value = await getUserById(userId);
  emit('selecteduser', user.value);
};

onMounted(() =>{ 
  fetchUser(props.userId);
});

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

