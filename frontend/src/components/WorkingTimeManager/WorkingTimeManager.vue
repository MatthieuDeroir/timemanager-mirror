<!-- This component will be changed after we add a data visualization librairy -->
<template>
    <div class="working-times">
        <h2>Management of the working times for User : {{ userId }}</h2>

        <div v-if="loading">Loading...</div>
        <div v-if="error" class="error">Failed to load working times: {{ error }}</div>

        <!-- Hours worked table-->
        <table v-if="!loading && !error">
            <thead>
                <tr>
                    <th>Start Time</th>
                    <th>End Time</th>
                    <th>Total Hours Worked</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="time in workingTimes" :key="time.id">
                    <td>{{ new Date(time.start).toLocaleString() }}</td>
                    <td>{{ new Date(time.end).toLocaleString() }}</td>
                    <td>{{ calculateHoursWorked(time.start, time.end) }} hours</td>
                    <td>
                        <button @click="openEditModal(time)">Edit</button>
                        <button @click="deleteWorkingTime(time.id)">Delete</button>
                    </td>
                </tr>
            </tbody>
        </table>

        <!-- Create and modify working time -->
        <div class="working-time-form">
            <h3>{{ isEditing ? 'Edit Working Time' : 'Create Working Time' }}</h3>
            <label for="new-start">Start Time:</label>
            <input type="datetime-local" v-model="newWorkingTime.start" id="new-start" />

            <label for="new-end">End Time:</label>
            <input type="datetime-local" v-model="newWorkingTime.end" id="new-end" />

            <button @click="isEditing ? updateWorkingTime() : createWorkingTime()">
                {{ isEditing ? 'Update' : 'Create' }}
            </button>
        </div>
    </div>
</template>

<script src="./WorkingTimeManager.js"></script>
<style src="./WorkingTimeManager.css"></style>