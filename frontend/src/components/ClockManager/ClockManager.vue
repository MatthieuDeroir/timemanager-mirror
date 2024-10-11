<template>
    <div class="clock-manager-container">
        <div class="banner">
            <h1>Today's clock in/out</h1>
            <div class="clock-manager-header">
                <h3>{{ this.date }}</h3>
                <div class="clock-status" :class="currentClockStatus ? 'green' : 'red'"></div>
            </div>
        </div>
        <div>
            <div v-if="error">{{ this.error }}</div>
            <div v-else-if="loading">Chargement...</div>
            <div v-else>
                <div class="row-clock" v-for="(item,index) in items" :key="index">
                    <div v-if="item.status">clock-out</div>
                    <div v-else>clock-in</div>
                    <div>
                        {{ this.getTime(item) }}

                    </div>
                </div>
            </div>  
            <div>
                <button @click="handleCreateClock">Clock</button>
            </div>
        </div>
    </div>
</template>
<script src="./ClockManager.js"/>
<style src="./ClockManager.css"/>