<template>
  <div v-if="loading">
    <LoaderComponent></LoaderComponent>
  </div>
  <div v-else class="user-tile">
    <div class="category">
      <div class="title">Employee</div>
      <div class="infos">
        <div class="label">Birthdate:</div>
        <div v-if="editStatus">
          <input class="input-date" type="date" v-model="user.birthdate"/>
        </div>
        <div v-else>
          <div>{{ user.birthdate }}</div>
        </div>
      </div>

      <div class="infos">
        <div class="label">Phone:</div>
        <div v-if="editStatus">
          <input class="input-text" type="text" v-model="user.phone" />
        </div>
        <div v-else>
          <div>{{ user.phone }}</div>
        </div>
      </div>

      <div class="infos">
        <div class="label">Address:</div>
        <div v-if="editStatus">
          <input class="input-text" type="text" v-model="user.address" />
        </div>
        <div v-else>
          <div>{{ user.address }}</div>
        </div>
      </div>
      
      <div class="infos">
        <div class="label">Username:</div>
        <div v-if="editStatus">
          <input class="input-text" type="text" v-model="user.username" />
        </div>
        <div v-else>
          <div>{{ user.username }}</div>
        </div>
      </div>

      <div v-if="editStatus">
        <div class="infos">
          <div class="label">Firstname:</div>
            <input class="input-text" type="text" v-model="user.firstname" />
        </div>
      </div>

      <div v-if="editStatus">
        <div class="infos">
          <div class="label">Lastname:</div>
            <input class="input-text" type="text" v-model="user.lastname" />
        </div>
      </div>

      <div v-if="editStatus">
        <div class="infos">
          <div class="label">Email:</div>
            <input class="input-text" type="text" v-model="user.email" />
        </div>  
      </div>

      <div v-if="editStatus">
        <div class="infos">
          <div class="label">Gender:</div>
            <input class="input-text" type="text" v-model="user.gender" />
        </div>  
      </div>
    </div>
    <div class="category">
      <div class="title">Contract</div>
      <div class="infos">
        <div class="label">Salary:</div>
        <div v-if="editStatus">
          <input class="input-number" type="number" v-model="user.salary" />
        </div>
        <div v-else>
          <div>{{ user.salary ?? 0 }} hints/month</div>
        </div>
      </div>
      <div class="infos">
        <div class="label">Position:</div>
        <div v-if="editStatus">
          <input class="input-text" type="text" v-model="user.position" />
        </div>
        <div v-else>
          <div>{{ user.position }}</div>
        </div>
      </div>
      <div class="infos">
        <div class="label">Start Date:</div>
        <div v-if="editStatus">
          <input class="input-date" type="date" v-model="user.start_date" />
        </div>
        <div v-else>
          <div>{{ user.start_date }}</div>
        </div>
      </div>
      <div class="infos">
        <div class="label">End Date:</div>
        <div v-if="editStatus">
          <input class="input-date" type="date" v-model="user.end_date" />
        </div>
        <div v-else>
          <div>{{ user.end_date }}</div>
        </div>
      </div>
    </div>
    <div class="user-edit">
      <div v-if="editStatus" class="user-edit-buttons">
        <button class="btn-primary" @click="handleSaveEdit">Save</button>
        <button class="btn-danger" @click="handleCancelEdit">Cancel</button>
      </div>
      <div v-else>
        <svg xmlns="http://www.w3.org/2000/svg" @click="handleTurnOnEdit" class="edit-icon" viewBox="0 0 24 24"><path d="M5,3C3.89,3 3,3.89 3,5V19A2,2 0 0,0 5,21H19A2,2 0 0,0 21,19V12H19V19H5V5H12V3H5M17.78,4C17.61,4 17.43,4.07 17.3,4.2L16.08,5.41L18.58,7.91L19.8,6.7C20.06,6.44 20.06,6 19.8,5.75L18.25,4.2C18.12,4.07 17.95,4 17.78,4M15.37,6.12L8,13.5V16H10.5L17.87,8.62L15.37,6.12Z" /></svg>
      </div>
    </div>
  </div>

</template>
<style src="./UserDisplay.css"></style>
<script setup>
import { onMounted, ref, watch } from 'vue';
import LoaderComponent from '@components/Loader/LoaderComponent.vue';
import { getUserById, updateUser} from '@services/userServices.js';


const props = defineProps({
  userId: {
    type: Number,
    required: true,
  }
});
const loading = ref({});
const editStatus = ref(false);
const user = ref({});
const emit = defineEmits(['selecteduser']);
const fetchUser = async (userId) => {
  user.value = await getUserById(userId);
  user.value.birthdate = new Date(user.value.birthdate).toLocaleDateString('en-GB', {
    day: '2-digit',
    month: 'long',
    year: 'numeric'
  });user.value.start_date = new Date(user.value.start_date).toLocaleDateString('en-GB', {
    day: '2-digit',
    month: 'long',
    year: 'numeric'
  });user.value.end_date= new Date(user.value.end_date).toLocaleDateString('en-GB', {
    day: '2-digit',
    month: 'long',
    year: 'numeric'
  });
  loading.value = false;
  emit('selecteduser', user.value);
};

function handleTurnOnEdit() {
  editStatus.value = editStatus.value = true;
}
function handleSaveEdit() {
  user.value.birthdate = new Date(user.value.birthdate).toISOString().split('T')[0];
  user.value.start_date = new Date(user.value.start_date).toISOString().split('T')[0];
  user.value.end_date = new Date(user.value.end_date).toISOString().split('T')[0];
  updateUser(user.value.id, user.value);
  editStatus.value = false;
  fetchUser(props.userId);
}
function handleCancelEdit() {
  editStatus.value = editStatus.value = false;
  fetchUser(props.userId);
}
onMounted(() => {
  loading.value = true;
  fetchUser(props.userId);
});

watch(() => props.userId, (newUserId) => {
  fetchUser(newUserId);
});

</script>
