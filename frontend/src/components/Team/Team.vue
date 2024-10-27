<template>
  <!--  <div v-if="teamStore.error">{{ teamStore.error }}</div>-->
  <div v-if="teamStore.isLoading">
    <Loader></Loader>
  </div>
  <v-expansion-panels v-else>
    <h3 v-if="teamStore.teams.length <= 0" class="no-team">You are not affected to any teams</h3>
    <v-expansion-panel v-for="team in teamStore.teams" :key="team.id">
      <v-expansion-panel-title>
        <h3>{{ team.name }}</h3>
      </v-expansion-panel-title>
      <v-expansion-panel-text v-if="team.users.length !== 0">
        <v-table density="compact">
          <thead>
            <tr>
              <th>Role</th>
              <th>Position</th>
              <th>First Name</th>
              <th>Last Name</th>
              <th>Contact</th>
              <td v-if="authStore.user.role_id !== UserRole.EMPLOYEE">
                <svg
                  class="add-user-in-team"
                  style="cursor: pointer"
                  viewBox="0 0 24 24"
                  xmlns="http://www.w3.org/2000/svg"
                  @click="handleAddUserInTeam"
                >
                  <path d="M19,13H13V19H11V13H5V11H11V5H13V11H19V13Z" />
                </svg>
              </td>
            </tr>
          </thead>
          <tbody>
            <TeamAddUser
              v-if="addUserState"
              :team_id="team.id"
              class="add-user-input"
              @onUserAddedToTeam="handleUserAddedInTeam"
            />
            <tr
              v-for="user in team.users"
              :key="user.id"
              :style="authStore.user.role_id !== UserRole.EMPLOYEE ? { cursor: 'pointer' } : {}"
              @click="handleOpenUserInfo(user.id)"
            >
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
                <svg
                  class="delete-user-from-team"
                  height="45px"
                  style="cursor: pointer"
                  viewBox="0 0 24 24"
                  width="45px"
                  xmlns="http://www.w3.org/2000/svg"
                  @click="handleDeleteUserFromTeam(team.id, user.id)"
                >
                  <g id="SVGRepo_iconCarrier">
                    <path
                      d="M15 12H9"
                      stroke="darkorange"
                      stroke-linecap="round"
                      stroke-width="1.5"
                    />
                  </g>
                </svg>
              </td>
            </tr>
          </tbody>
        </v-table>
        <div class="delete-team">
          <button
            v-if="this.authStore.user.role_id === UserRole.ADMIN"
            class="btn-danger"
            @click="handleDeleteTeam(team.id)"
          >
            Delete Team
          </button>
        </div>
      </v-expansion-panel-text>
      <v-expansion-panel-text v-else>
        <p style="width: 100%; text-align: center">No users found for this team.</p>
        <div class="delete-team">
          <button
            v-if="this.authStore.user.role_id === UserRole.ADMIN"
            class="btn-danger"
            @click="handleDeleteTeam(team.id)"
          >
            Delete Team
          </button>
        </div>
      </v-expansion-panel-text>
    </v-expansion-panel>
  </v-expansion-panels>
  <div v-if="this.authStore.user?.role_id === UserRole.ADMIN" class="team-create">
    <form @submit="handleCreateTeam">
      <input class="team-name-input" type="text" />
      <button class="btn-primary" type="submit">Create Team</button>
    </form>
  </div>
</template>
<style src="./Team.css" />
<script>
import { ref } from 'vue'
import { UserRole } from '@enum/User/UserRole'
import emailIcon from '@assets/icons/icons8-mail-48.png'
import { useAuthStore } from '@store/Auth/AuthStore.js'
import { useTeamStore } from '@store/Team/TeamStore.js'
import { useRouter } from 'vue-router'
import { useClockStore } from '@store/Clock/ClockStore.js'
import { useWorkingTimeStore } from '@store/WorkingTime/WorkingTimeStore.js'
import Loader from '@components/Loader/LoaderComponent.vue'
import TeamAddUser from '@components/Team/TeamAddUser/TeamAddUser.vue'

export default {
  props: {
    userId: {
      type: [String, Number]
    }
  },
  setup() {
    const teamStore = useTeamStore()
    const authStore = useAuthStore()
    const router = useRouter()
    const clockStore = useClockStore()
    const workingTimesStore = useWorkingTimeStore()
    const addUserState = ref(false)

    const handleCreateTeam = (event) => {
      event.preventDefault()
      const teamName = event.target.querySelector('.team-name-input').value
      if (teamName !== '') {
        teamStore.createTeam(teamName)
        event.target.querySelector('.team-name-input').value = ''
      }
    }
    const handleOpenUserInfo = (userId) => {
      if (authStore.user.role_id === UserRole.EMPLOYEE) return

      clockStore.loadClocks(userId)
      workingTimesStore.loadWorkingTimes(userId)
      if (authStore.user.role_id === UserRole.MANAGER) {
        router.push({ name: 'Manager', params: { userId: authStore.user.id, workerId: userId } })
      }
      if (authStore.user.role_id === UserRole.ADMIN) {
        router.push({ name: 'Administrator', params: { userId } })
      }
    }
    const handleAddUserInTeam = () => {
      addUserState.value = true
    }
    const handleUserAddedInTeam = () => {
      addUserState.value = false
    }

    const handleDeleteUserFromTeam = (user_id, team_id) => {
      teamStore.teams.map((team) => {
        if (team.id === team_id) {
          team.users = team.users.filter((user) => user.id !== user_id)
        }
      })
      teamStore.deleteUserInTeam(user_id, team_id)
    }

    const handleDeleteTeam = (teamId) => {
      teamStore.teams = teamStore.teams.filter((team) => team.id !== teamId)
      teamStore.deleteTeam(teamId)
    }

    const getRoleName = (role_Id) => {
      if (role_Id === UserRole.ADMIN) {
        return 'Admin'
      } else if (role_Id === UserRole.MANAGER) {
        return 'Manager'
      } else if (role_Id === UserRole.EMPLOYEE) {
        return 'Employee'
      } else {
        return 'Unknown Role'
      }
    }
    return {
      handleDeleteTeam,
      handleCreateTeam,
      handleAddUserInTeam,
      handleUserAddedInTeam,
      handleDeleteUserFromTeam,
      handleOpenUserInfo,
      getRoleName,
      addUserState,
      emailIcon,
      teamStore,
      authStore,
      UserRole
    }
  },
  mounted() {
    if (this.authStore.user.role_id === UserRole.ADMIN || UserRole.GENERAL_MANAGER) {
      this.teamStore.loadAllTeams()
    } else {
      this.teamStore.loadTeamByUserId(this.authStore.user.id)
    }
  },
  components: {
    Loader,
    TeamAddUser
  }
}
</script>
<style src="./Team.css" />
