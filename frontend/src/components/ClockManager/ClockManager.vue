<template>
    <div v-if="loading" >
        <LoaderComponent />
    </div>
    <div v-else>
        <div class="clock-manager-container">
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
            <div v-if="items.length == 0" class="center">
                No Check-in yet
            </div>
            <div class="center">
                <button class="btn-primary" @click="handleCreateClock">Clock</button>
            </div>
        </div>
    </div>
</template>
<script src="./ClockManager.js"></script>
<style src="./ClockManager.css" />