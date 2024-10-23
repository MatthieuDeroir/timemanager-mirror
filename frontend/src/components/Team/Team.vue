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