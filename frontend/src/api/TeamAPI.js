import {HttpClient} from '@/api/config/HttpClient.js'

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL


/**
 * getAllTeams
 * This method find all teams. Inside a component, you can use the store and the store will call this method to store the data.
 */
export const getAllTeams = () =>
    HttpClient.get(`${API_BASE_URL}/teams`)
        .then((res) => res.data)
        .catch((error) => {
        console.error('Error fetching teams:', error)
        throw error
        })

/**
 * getAllUsersFromTeam
 * This method find a team by id.
 * @param teamId
 * @returns {Promise<axios.AxiosResponse<any>>}
 */
export const getAllUsersFromTeam = (teamId) => HttpClient.get(`${API_BASE_URL}/teams/${teamId}`).then((res) => res.data)

/**
 * getTeamsFromUser
 * This method find a team by id.
 * @param userId
 * @returns {Promise<axios.AxiosResponse<any>>}
 */
export const getTeamsFromUser = (userId) => HttpClient.get(`${API_BASE_URL}/users/teams/${userId}`).then((res) => res.data)

/**
 * addUsersToTeam
 * this method add a user to a team
 * @param userId
 * @param teamId
 */
export const addUsersToTeam = (userId, teamId) => HttpClient.post(`${API_BASE_URL}/users/add/`,{userId,teamId})
    .then((res) => res.data)
    .catch((error) => {
        console.error('Error adding user to team:', error)
        throw error
    })

/**
 * removeUsersFromTeam
 * this method add a user to a team
 * @param userId
 * @param teamId
 */
export const removeUsersFromTeam = (userId, teamId) => HttpClient.delete(`${API_BASE_URL}/users/remove/`,{userId,teamId})
    .then((res) => res.data)
    .catch((error) => {
        console.error('Error removing a user from a team:', error)
        throw error
    })

/**
 * createTeam
 * this create a new team
 * @param {string} start
 * @param {string} end
 * @returns {Promise<axios.AxiosResponse<any>>}
 */
export const createTeam = (id, name) => HttpClient.post(`${API_BASE_URL}/teams/`,{
    data:{id, name}
})
    .then((res) => res.data)
    .catch((error) => {
        console.error('Error adding a new team:', error)
        throw error
    })


/**
 * updateTeam
 * this method update information of a team
 * @param {int} id
 * @param {string} name
 * @param {number} teamId
 * @returns {Promise<axios.AxiosResponse<any>>}
 */
export const updateTeam = (teamId, id, name) => HttpClient.put(`${API_BASE_URL}/teams/${teamId}`,{
    data:{id,name}
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
export const deleteTeam = (teamId) => HttpClient.delete(`${API_BASE_URL}/teams/${teamId}`)
    .then((res) => res.data)
    .catch((error) => {
        console.error('Error updating team:', error)
        throw error
    })