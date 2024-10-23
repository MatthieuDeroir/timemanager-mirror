<template>
  <div v-if="teamError">{{ teamError }}</div>  
  <div v-if="teamLoading"> <Loader></Loader></div>
  <v-expansion-panels v-else>
    <h3 v-if="teams.length<=0" class="no-team">You are not affected to any teams</h3>
    <v-expansion-panel  v-for="team in teams" :key="team.id">
      <v-expansion-panel-title>
        <div class="team-expansion-panel">
          <h3>{{ team.name }} </h3>
          <svg v-if="authStore.user.role_id != UserRole.EMPLOYEE" class="add-user-in-team" @click="handleAddUserInTeam" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><title>minus</title><path d="M19,13H13V19H11V13H5V11H11V5H13V11H19V13Z" /></svg>
        </div>
      </v-expansion-panel-title>
      <v-expansion-panel-text v-if="team.users">
        <v-table density="compact" fixed-header="true">
          <thead>
            <tr>
              <th>Role</th>
              <th>Position</th>
              <th>First Name</th>
              <th>Last Name</th>
              <th>Contact</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="user in team.users" :key="user.id">
              <td>{{ getRoleName(user.role_id) }}</td>
              <td>{{ user.position }}</td>
              <td>{{ user.firstname }}</td>
              <td>{{ user.lastname }}</td>
              <td>
                <a :href="`mailto:${user.email}`" class="mailto-link">
                  <img :src="emailIcon" alt="Email Us" />
                </a>
              </td>
              <td v-if="authStore.user.role_id != UserRole.EMPLOYEE">
                <svg @click="handleDeleteUserFromTeam" width="40px" height="40px" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" stroke="#ff0000">
                  <g id="SVGRepo_bgCarrier" stroke-width="0"/>
                  <g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"/>
                  <g id="SVGRepo_iconCarrier"> <path d="M15 12H9" stroke="#d11a1a" stroke-width="1.5" stroke-linecap="round"/> <path d="M7 3.33782C8.47087 2.48697 10.1786 2 12 2C17.5228 2 22 6.47715 22 12C22 17.5228 17.5228 22 12 22C6.47715 22 2 17.5228 2 12C2 10.1786 2.48697 8.47087 3.33782 7" stroke="#d11a1a" stroke-width="1.5" stroke-linecap="round"/> </g>
                </svg>
              </td>
            </tr>
          </tbody>
        </v-table>
        <p v-if="team.users.length == 0">No users found for this team.</p>
      </v-expansion-panel-text>
      <v-expansion-panel-text v-else>
        Issue loading users for this team.
      </v-expansion-panel-text>
    </v-expansion-panel>
  </v-expansion-panels>
  <div v-if="authStore.user.role_id === UserRole.ADMIN" class="team-create">
    <form @submit="handleCreateTeam">
      <input type="text" class="team-name-input">
      <button type="submit" class="btn-primary">Create Team</button>
    </form>
  </div>
</template>
<style src="./Team.css"/>
<script lang="ts" setup>
import { ref, onMounted, computed } from 'vue';
import { UserRole } from '@enum/User/UserRole';
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

const handleCreateTeam = (event) => {
  event.preventDefault();
  const teamName = event.target.querySelector('.team-name-input').value;
  if (teamName != ''){
    teamStore.createTeam(teamName)
  }
};

const handleAddUserInTeam = () => {
  //TODO
};
const handleDeleteUserFromTeam = () => {
  //TODO
};

onMounted(() => {
  if (authStore.user.role_id === UserRole.ADMIN) {
    teamStore.loadAllTeams();
  } else {
    teamStore.loadTeamByUserId(authStore.user.id)
  }
});


const getRoleName = (role_Id) => {
    if (role_Id === UserRole.ADMIN) {
      return 'Admin';
    } else if (role_Id === UserRole.MANAGER) {
      return 'Manager';
    } else if (role_Id === UserRole.EMPLOYEE) {
      return 'Employee';
    } else {
      return 'Unknown Role';
    } 
};

</script>




<style src="./Team.css"/>