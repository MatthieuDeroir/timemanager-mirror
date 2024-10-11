<!-- This component will be changed after we add a data visualization librairy -->
<template>
    <div class="working-times">
        <h2>Management of the working times for User : {{ userId }}</h2>

        <div v-if="loading">Loading...</div>
        <div v-if="error" class="error">{{ error }}</div>

        <!-- Bouton pour ajouter une nouvelle ligne -->
        <button @click="addNewWorkingTime">Add new working time</button>

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
                <tr v-for="time in workingTimes" :key="time.id || time.tempId">
                    <td>
                        <input
                            v-if="time.isEditing"
                            type="datetime-local"
                            v-model="time.start"
                        />
                        <span v-else>{{ new Date(time.start).toLocaleString() }}</span>
                    </td>
                    <td>
                        <input
                            v-if="time.isEditing"
                            type="datetime-local"
                            v-model="time.end"
                        />
                        <span v-else>{{ new Date(time.end).toLocaleString() }}</span>
                    </td>
                    <td>{{ calculateHoursWorked(time.start, time.end) }} hours</td>
                    <td>
                        <button v-if="time.isEditing" @click="saveWorkingTime(time)">Save</button>
                        <button v-else @click="editWorkingTime(time)">Edit</button>
                        <button @click="deleteWorkingTime(time.id || time.tempId)">Delete</button>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</template>




<script src="./WorkingTimeManager.js"></script>
<style src="./WorkingTimeManager.css"></style>