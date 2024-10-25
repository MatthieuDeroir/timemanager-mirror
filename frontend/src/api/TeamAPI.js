import { HttpClient } from '@/api/config/HttpClient.js'

/**
 * getAllTeams
 * This method find all teams. Inside a component, you can use the store and the store will call this method to store the data.
 */
export const getAllTeams = () =>
  HttpClient.get(`/teams`)
    .then((res) => res.data)
    .catch((error) => {
      console.error('Error fetching teams:', error)
      throw error
    })

/**
 * getTeamsByUserId
 * This method finds all team by user_id.
 * @param userId
 * @returns {Promise<axios.AxiosResponse<any>>}
 */
export const getTeamsByUserId = (userId) =>
  HttpClient.get(`/users/teams/${userId}`)
    .then((res) => res.data)
    .catch((error) => {
      console.error('Error fetching teams:', error)
      throw error
    })

export const getUsersFromTeamId = (teamId) =>
  HttpClient.get(`/teams/users/${teamId}`)
    .then((res) => res.data)
    .catch((error) => {
      console.error('Error fetching teams:', error)
      throw error
    })

export const addUserInTeam = (user_id, team_id) =>
  HttpClient.post(`/user_teams/add`, { user_id, team_id })
    .then((res) => res.data)
    .catch((error) => {
      console.error('Error adding a new user in team:', error)
      throw error
    })

export const deleteUserInTeam = (user_id, team_id) =>
  HttpClient.post(`/user_teams/remove`, { user_id, team_id })
    .then((res) => res.data)
    .catch((error) => {
      console.error('Error deleting a user in team:', error)
      throw error
    })

/**
 * createTeam
 * this create a new team
 * @returns {Promise<axios.AxiosResponse<any>>}
 * @param name
 */
export const createTeam = (name) =>
  HttpClient.post(`/teams/`, {
    team: { name }
  })
    .then((res) => res.data)
    .catch((error) => {
      console.error('Error adding a new team:', error)
      throw error
    })

/**
 * updateTeam
 * this method update information of a team
 * @param {string} name
 * @param {number} teamId
 * @returns {Promise<axios.AxiosResponse<any>>}
 */
export const updateTeam = (teamId, name) =>
  HttpClient.put(`/teams/${teamId}`, {
    data: { teamId, name }
  })
    .then((res) => res.data)
    .catch((error) => {
      console.error('Error updating team:', error)
      throw error
    })

/**
 * deleteTeam
 * this method update information of a team
 * @param {number} teamId
 * @returns {Promise<axios.AxiosResponse<any>>}
 */
export const deleteTeam = (teamId) =>
  HttpClient.delete(`/teams/${teamId}`)
    .then((res) => res.data)
    .catch((error) => {
      console.error('Error updating team:', error)
      throw error
    })

export default {
  getAllTeams,
  getTeamsByUserId,
  getUsersFromTeamId,
  addUserInTeam,
  deleteUserInTeam,
  createTeam,
  updateTeam,
  deleteTeam
}
