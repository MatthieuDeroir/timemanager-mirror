import {defineStore} from 'pinia'
import teamApi, {getUsersFromTeamId} from '@/api/TeamAPI.js'

export const useTeamStore = defineStore('teamStore', {
    state: () => ({
        teams: [],
        isLoading: false,
        error: null
    }),

    actions: {
        async loadAllTeams() {
            this.isLoading = true
            this.error = null
            const result = await teamApi.getAllTeams().catch((error) => {
                this.error = error
            })
            await this.getUsersInManyTeams(result)
            console.log('store',this.teams)
            this.isLoading = false
        },
        async loadTeamByUserId(userId) {
            this.isLoading = true
            this.error = null
            const result = await teamApi.getTeamsByUserId(userId)
            await this.getUsersInManyTeams(result)
            this.isLoading = false
        },
        async getUsersInManyTeams(teams){
            for (const [index,element] of teams.entries()) {
                if (this.teams[index] === undefined) {
                    this.teams[index]= {}
                }
                this.teams[index].users = await teamApi.getUsersFromTeamId(element.id)
                this.teams[index].id = element.id
                this.teams[index].name = element.name
            }
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