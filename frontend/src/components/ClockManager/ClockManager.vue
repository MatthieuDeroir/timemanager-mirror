<template>
    <div>
        <div v-if="latestClockStatus">green</div>
        <div v-else-if="latestClockStatus == false">red</div>
        <h1>ClockManager</h1>
        <div>
            <div v-if="error">{{ this.error }}</div>
            <div v-else-if="loading">Loading...</div>
            <div v-else>
                <div>
                    <li v-for="(item,index) in items" :key="index">
                        {{ item.status }}  {{ item.user_id }}
                    </li>
                </div>
            </div>  
            <div>
                <button @click="handleCreateClock">Clock</button>
            </div>
        </div>
    </div>
</template>
<script src="./ClockManager.js"/>