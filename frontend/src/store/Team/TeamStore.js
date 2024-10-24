import {defineStore} from 'pinia'
import teamApi, {getUsersFromTeamId} from '@/api/TeamAPI.js'
import {ca} from "vuetify/locale";

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
            try {
                const result = await teamApi.getAllTeams()
                await this.getUsersInManyTeams(result)
            } catch (error) {
                this.error = error
            }finally {
                this.isLoading = false
            }
        },
        async loadTeamByUserId(userId) {
            this.isLoading = true
            this.error = null
            try {
                const result = await teamApi.getTeamsByUserId(userId)
                await this.getUsersInManyTeams(result)
            }catch (error) {
                this.error = error
            }finally {
                this.isLoading = false
            }
        },
        async getUsersInManyTeams(teams){
            try {
                for (const [index,element] of teams.entries()) {
                    if (this.teams[index] === undefined) {
                        this.teams[index]= {}
                    }
                    this.teams[index].users = await teamApi.getUsersFromTeamId(element.id)
                    this.teams[index].id = element.id
                    this.teams[index].name = element.name
                }
            }catch (error) {
                this.error = error
            }
        },
        async addUserInTeam(user_id, team_id) {
            this.isLoading = true
            this.error = null
            try {
                await teamApi.addUserInTeam(user_id, team_id)
            }catch (error) {
                this.error = error
            }finally {
                this.isLoading = false
            }
        },
        async deleteUserInTeam(user_id, team_id) {
            this.isLoading = true
            this.error = null
            try {
                await teamApi.deleteUserInTeam(user_id, team_id)
            }catch (error) {
                this.error = error
            }finally {
                this.isLoading = false
            }
        },
        async createTeam(name) {
           this.isLoading = true
           this.error = null
            try {
               const newTeam = await teamApi.createTeam(name)
               this.teams.push(newTeam)
            }catch (error) {
                this.error = error
            }finally {
                this.isLoading = false
            }
        },
        async updateTeam(teamId, name) {
            this.isLoading = true
            this.error = null
            try {
                const updatedTeam = await teamApi.updateTeam(teamId, name)
                this.teams = this.teams.map((team) => (team.teamId === teamId ? updatedTeam : team))
            }catch (error) {
                this.error = error
            }finally {
                this.isLoading = false
            }
        },
        async deleteTeam(teamId) {
            this.isLoading = true
            this.error = null
            try {
                await teamApi.deleteTeam(teamId)
                this.teams = this.teams.filter((team) => team.teamId !== teamId)
            }catch (error) {
                this.error = error
            }finally {
                this.isLoading = false
            }
        }
    }
})