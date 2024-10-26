import { defineStore } from 'pinia'
import teamApi from '@/api/TeamAPI.js'
import { ref } from 'vue'
import { handleApiRequest } from '@config/lokiJS/syncHelper'
import { useToast } from 'vue-toast-notification'
import 'vue-toast-notification/dist/theme-sugar.css'

/**
 * Store for teams.
 * You can import this store in your components and use it to manage teams.
 * @example import { useTeamStore } from '@/store/TeamStore'
 * @example const teamStore = useTeamStore()
 * @example teamStore.loadAllTeams()
 */
export const useTeamStore = defineStore('teamStore', () => {
  const teams = ref([])
  const isLoading = ref(false)
  const $toast = useToast()
  const options = {
    position: 'top-left',
    duration: 1000,
    dismissible: true
  }
  /**
   * Loads all teams from the API.
   * Sets the `isLoading` state to true while loading and false after loading.
   */
  const loadAllTeams = async () => {
    isLoading.value = true
    const result = await handleApiRequest('get', {}, 'getAllTeams')
    await getUsersInManyTeams(result)
    isLoading.value = false
  }

  /**
   * Loads teams associated with a specific user.
   * @param userId
   */
  const loadTeamByUserId = async (userId) => {
    isLoading.value = true
    const result = await handleApiRequest('get', userId, 'getTeamsByUserId')
    await getUsersInManyTeams(result)
    isLoading.value = false
  }

  /**
   * Adds users to multiple teams.
   * This method iterates over the provided teams and fetches the users for each.
   * @param teamsData
   */
  const getUsersInManyTeams = async (teamsData) => {
    for (const [index, team] of teamsData.entries()) {
      if (!teams.value[index]) {
        teams.value[index] = {}
      }
      teams.value[index].users = await teamApi.getUsersFromTeamId(team.id)
      teams.value[index].id = team.id
      teams.value[index].name = team.name
    }
  }

  /**
   * Adds a user to a team.
   * @param user_id
   * @param team_id
   */
  const addUserInTeam = async (user_id, team_id) => {
    isLoading.value = true
    await handleApiRequest('create', { user_id, team_id }, 'addUserInTeam')
    $toast.success('Employee successfully added to the team.', options)
    isLoading.value = false
  }

  /**
   * Deletes a user from a team.
   * @param user_id
   * @param team_id
   */
  const deleteUserInTeam = async (user_id, team_id) => {
    isLoading.value = true
    await handleApiRequest('delete', { user_id, team_id }, 'deleteUserInTeam')
    $toast.success('Employee successfully removed of the team.', options)
    isLoading.value = false
  }

  /**
   * Creates a new team.
   * @param name
   */
  const createTeam = async (name) => {
    isLoading.value = true
    const newTeam = await handleApiRequest('create', name, 'createTeam')
    $toast.success('Team successfully created.', options)
    teams.value.push(newTeam)
    isLoading.value = false
  }

  /**
   * Updates a team.
   * @param teamId
   * @param name
   */
  const updateTeam = async (teamId, name) => {
    isLoading.value = true
    const updatedTeam = await handleApiRequest('update', { name }, 'updateTeam', teamId)
    teams.value = teams.value.map((team) => (team.id === teamId ? updatedTeam : team))
    $toast.success('Team successfully edited.', options)
    isLoading.value = false
  }

  /**
   * Deletes a team.
   * @param teamId
   */
  const deleteTeam = async (teamId) => {
    isLoading.value = true
    await handleApiRequest('delete', {}, 'deleteTeam', teamId)
    teams.value = teams.value.filter((team) => team.id !== teamId)
    $toast.success('Team successfully deleted.', options)
    isLoading.value = false
  }

  return {
    teams,
    isLoading,
    loadAllTeams,
    loadTeamByUserId,
    getUsersInManyTeams,
    addUserInTeam,
    deleteUserInTeam,
    createTeam,
    updateTeam,
    deleteTeam
  }
})
