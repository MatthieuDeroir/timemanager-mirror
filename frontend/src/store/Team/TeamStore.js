import { defineStore } from 'pinia'
import teamApi from '@/api/TeamAPI.js'

export const useTeamStore = defineStore('teamStore', {
    state: () => ({
        teams: [],
        isLoading: false,
        error: null
    }),

    actions: {
        async loadTeamByUserId(userId) {
            this.isLoading = true
            this.error = null
            const result = await teamApi.getTeamsByUserId(userId)
            result.forEach((element, index) => {
                if (this.teams[index] === undefined) {
                    this.teams[index]= {}
                }
                teamApi.getUsersFromTeamId(element.id)
                    .then((res) => this.teams[index].users = res.data)
                    .catch((error) => {
                        this.error = error
                    })
                this.teams[index].teamId = element.id
                this.teams[index].name = element.name
            });
            this.isLoading = false
        },
        async addUserInTeam(teamId, userId) {
            this.isLoading = true
            this.error = null
            await teamApi.addUserInTeam(teamId, userId)
            this.isLoading = false
        },
        async deleteUserInTeam(teamId, userId) {
            this.isLoading = true
            this.error = null
            await teamApi.deleteUserInTeam(teamId, userId)
            this.isLoading = false
        },        
        async createTeam(name) {
           this.isLoading = true
           this.error = null
           const newTeam = await teamApi.createTeam(name)
           this.teams.push(newTeam)
           this.isLoading = false
        },
        async updateTeam(teamId, name) {
            this.isLoading = true
            this.error = null
            const updatedTeam = await teamApi.updateTeam(teamId, name)
            this.teams = this.teams.map((team) => (team.teamId === teamId ? updatedTeam : team))
            this.isLoading = false
        },
        async deleteTeam(teamId) {
            this.isLoading = true
            this.error = null
            await teamApi.deleteTeam(teamId)
            this.teams = this.teams.filter((team) => team.teamId !== teamId)
            this.isLoading = false
        }
    }
})