import { defineStore } from 'pinia'
import TeamAPI from '@/api/TeamAPI'

const { getAllTeams, getAllUsersFromTeam, getTeamsFromUser, addUsersToTeam, removeUsersFromTeam, createTeam, updateTeam, deleteTeam } = TeamAPI

export const useTeamStore = defineStore('teamStore', {
    state: () => ({
        teams: [],
        isLoading: false,
        error: null
    }),

    actions: {
        async loadTeams(start = null, end = null) {
            this.isLoading = true
            this.error = null
            try {
                this.teams = await getAllTeams(start, end)
            } catch (error) {
                this.error = error
            } finally {
                this.isLoading = false
            }
        },
        async loadTeam(teamId, start = null, end = null) {
            this.isLoading = true
            this.error = null
            try {
                this.teams = await getTeam(teamId, start, end)
            } catch (error) {
                this.error = error
            } finally {
                this.isLoading = false
            }
        },
        async createNewTeam(data) {
            this.isLoading = true
            this.error = null
            const newTeam = await createTeam(data)
            this.teams.push(newTeam)
            this.isLoading = false
        },
        async loadUsersFromTeam(teamId) {
            this.isLoading = true
            this.error = null
            this.teams = await getAllUsersFromTeam(teamId)
            this.isLoading = false
        },
        async loadTeamsFromUser(userId) {
            this.isLoading = true
            this.error = null
            this.teams = await getTeamsFromUser(userId)
            this.isLoading = false
        },
        async addUserToTeam(userId, teamId) {
            this.isLoading = true
            this.error = null
            const newTeamMemeber = await addUsersToTeam(userId, teamId)
            this.teams.user.push(newTeamMemeber)
            this.isLoading = false
        },
        async removeUsersFromTeam(teamId, userId) {
            this.isLoading = true
            this.error = null
            await removeUsersFromTeam(userId, teamId)
            this.teams.user = this.teams.user.filter((wt) => wt.userId !== userId)
            this.isLoading = false
        },
        async updateTeam(teamId, data) {
            this.isLoading = true
            this.error = null
            await updateTeam(teamId, data)
            this.teams = this.teams.map((wt) => wt.teamId !== teamId)
            this.isLoading = false
        },
        async deleteTeam(teamId) {
            this.isLoading = true
            this.error = null
            await deleteTeam(teamId)
            this.teams = this.teams.filter((wt) => wt.teamId !== teamId)
            this.isLoading = false
        }
    }
})