<template>
    <div class="clock-manager-container">
        <div v-if="error">{{ this.error }}</div>
        <div v-else-if="loading">
            <LoaderComponent />
        </div>
        <div v-else>
            <div class="banner">
                <div class="clock-manager-header">
                    <h3>Work status</h3>
                    <div class="clock-status" :class="currentClockStatus ? 'green' : 'red'"></div>
                </div>
            </div>
            <div class="row-clock-container">
                <div v-for="(item) in items">
                    <div v-if="item.status" class="row-clock">
                        <img src="@assets/icons/green-arrow.png" class="arrow-icon">
                        <div class="row-clock-details">
                            <div class="clock-time">{{ this.getTime(item) }}</div>
                            <div class="clock-type">Check-in</div>
                        </div>
                    </div>
                    <div v-else class="row-clock">
                        <img src="@assets/icons/red-arrow.png" class="arrow-icon">
                        <div class="row-clock-details">
                            <div class="clock-time">{{ this.getTime(item) }}</div>
                            <div class="clock-type">Check-out</div>
                        </div>
                    </div>
                </div>
            </div>
            <div>
                <button @click="handleCreateClock">Clock</button>
            </div>
        </div>
    </div>
</template>
<script src="./ClockManager.js"></script>
<style src="./ClockManager.css" />