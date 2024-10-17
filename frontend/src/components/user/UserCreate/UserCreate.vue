<template>
    <div class="off-side">
        <Card style="z-index: 10000;" title="Create user" 
        :logo="AddUser"
        color="purple"
        actionButton='<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><title>close</title><path d="M19,6.41L17.59,5L12,10.59L6.41,5L5,6.41L10.59,12L5,17.59L6.41,19L12,13.41L17.59,19L19,17.59L13.41,12L19,6.41Z" /></svg>'
        :actionFunction="handleClickOut">
        
        <div class="create-container">
            <form @submit.prevent="createUser">
                <div class="sections-container">
                    <div class="employee-section">
                        <div class="input-container">
                            <label for="firstname">First Name</label>
                            <input type="text" id="firstname" v-model="user.firstname" >
                        </div>
                        <div class="input-container">
                            <label for="lastname">Last Name</label>
                            <input type="text" id="lastname" v-model="user.lastname" >
                        </div>
                        <div class="input-container">
                            <label for="address">Address</label>
                            <input type="text" id="address" v-model="user.address" >
                        </div>
                        <div class="input-container">
                            <label for="phone">Phone</label>
                            <input type="text" id="phone" v-model="user.phone" >
                        </div>
                        <div class="input-container">
                            <label for="birthdate">Birthdate</label>
                            <input type="date" id="birthdate" v-model="user.birthdate" >
                        </div>
                        <div class="input-container">
                            <label for="gender">Gender</label>
                            <input type="text" id="gender" v-model="user.gender" >
                        </div>
                        <div class="input-container">
                            <label for="username">Username</label>
                            <input type="text" id="username" v-model="user.username" required>
                        </div>
                        <div class="input-container">
                            <label for="email">Email</label>
                            <input type="email" id="email" v-model="user.email" required>
                        </div>
                    </div>
                    <div class="contract-section">
                        <div class="input-container">
                            <label for="salary">Salary</label>
                            <input type="number" id="salary" v-model="user.salary" >
                        </div>
                        <div class="input-container">
                            <label for="position">Position</label>
                            <input type="text" id="position" v-model="user.position" >
                        </div>
                        <div class="input-container">
                            <label for="start_date">Start Date</label>
                            <input type="date" id="start_date" v-model="user.start_date" >
                        </div>
                        <div class="input-container">
                            <label for="end_date">End Date</label>
                            <input type="date" id="end_date" v-model="user.end_date">
                        </div>
                        <div class="input-container">
                            <label for="password_hash">Password</label>
                            <input type="password" id="password_hash" v-model="user.password_hash" required>
                        </div>
                        <div class="input-container">
                            <label for="role_id">Role</label>
                            <input type="number" id="role_id" v-model="user.role_id" >
                        </div>
                        <div class="input-container">
                            <label for="team_id">Team</label>
                            <input type="number" id="team_id" v-model="user.team_id" >
                        </div>
                    </div>
                </div>
                <button class="btn-primary submit-create-user" type="submit">Create User</button>
            </form>
        </div>
    </Card>
    </div>
</template>
<style src="./UserCreate.css"></style>
<script setup>
    import { defineEmits,ref } from 'vue';
    import UserService from '@services/userServices.js';
    import Card from '@/components/Card/Card.vue';
    import AddUser from '@assets/icons/icons8-add-48.png';



    const user = ref({
                    firstname: '',
                    lastname: '',
                    address: '',
                    phone: '',
                    birthdate: '',
                    gender: '',
                    salary: '',
                    position: '',
                    start_date: '',
                    end_date: '',
                    username: '',
                    email: '',
                    password_hash: '',
                    role_id: '',
                    team_id: ''
                });

    const emit = defineEmits(['clickOut']);
    const handleClickOut = () => {
        emit('clickOut');
    }
    async function createUser() {
        console.log(user.value);
        const response = await UserService.createUser( /*TODO*/);
        console.log(response);
    }
</script>   