import { defineStore } from 'pinia'
import TeamAPI from '@/api/TeamAPI'

const { getTeams, getTeam, createTeam, updateTeam, deleteTeam } = TeamAPI

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
            this.teams = await getAllTeams(start, end)
            this.isLoading = false
        },
        async loadTeam (teamId, start = null, end = null) {
            this.isLoading = true
            this.error = null
            this.teams = await getTeam(teamId, start, end)
            this.isLoading = false
        },
        async createTeam(teamId, userId) {
            this.isLoading = true
            this.error = null
            const newTeam = await createTeam(teamId, userId)
            this.teams.push(newTeam)
            this.isLoading = false
        },
    }
})