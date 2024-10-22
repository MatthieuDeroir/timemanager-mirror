<template>
  <div v-if="teamError">{{ teamError }}</div>  
  <div v-if="teamLoading"> <Loader></Loader></div>
  <v-expansion-panels v-else>
    <h3 v-if="teams.length<=0" class="no-team">You are not affected to any teams</h3>
    <v-expansion-panel  v-for="team in teams" :key="team.id">
      <v-expansion-panel-title>
        <h3>{{ team.name }} </h3>
      </v-expansion-panel-title>
      <v-expansion-panel-text v-if="team.users">
        <div class="UserDiv">
          <span class="user-role">Role</span>
          <span class="user-position">Position</span>
          <span class="user-firstName">First Name</span>
          <span class="user-lastname">Last Name</span>
        </div>
        <div v-for="user in team.users" :key="user" class="UserDiv">
          <span class="user-role">{{ getRoleName(user.role_id) }}</span>
          <span class="user-position">{{ user.position }}</span>
          <span class="user-firstName">{{ user.firstname }}</span>
          <span class="user-lastname">{{ user.lastname }}</span>
          <a :href="`mailto:${user.email}`" class="mailto-link">
            <img :src="emailIcon" alt="Email Us" />
          </a>
          <hr/>
        </div>

        <p v-if="team.users.length === 0">No users found for this team.</p>
      </v-expansion-panel-text>
    <v-expansion-panel-text v-else>
      Issue loading users for this team.
    </v-expansion-panel-text>
    </v-expansion-panel>
  </v-expansion-panels>
</template>

<script lang="ts" setup>
import { ref, onMounted, computed } from 'vue';
import { UserRole } from '../../enum/User/UserRole';
import emailIcon from '@assets/icons/icons8-mail-48.png'
import { useAuthStore } from '@store/Auth/AuthStore.js'
import { useTeamStore } from '@store/Team/TeamStore.js'
import Loader from '@components/Loader/LoaderComponent.vue'

const props = defineProps({
  userId: {
    type: [String, Number],
    required: true,
  },
});

const teamStore = useTeamStore();
const authStore = useAuthStore();
const teams = teamStore.teams;
const teamLoading = computed(() => teamStore.isLoading);
const teamError = computed(() => teamStore.error);

onMounted(() => {
  teamStore.loadTeamByUserId(authStore.user.id)
});


const getRoleName = (role_Id) => {
    if (role_Id === UserRole.Admin) {
      return 'Admin';
    } else if (role_Id === UserRole.Manager) {
      return 'Manager';
    } else if (role_Id === UserRole.Employee) {
      return 'Employee';
    } else {
      return 'Unknown Role';
    } 
};

</script>




<style scoped>
.UserDiv {
  display: flex;
  align-items: center;
}

.user-firstname, .user-lastname, .user-position, .user-role {
  width: 100px;
  margin-right: 10px;
}
.no-team{
  margin:100px;
}

.mailto-link {
  display: flex;
  align-items: center; 
}



</style>
