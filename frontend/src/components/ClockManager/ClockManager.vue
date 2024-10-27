<template>
  <div v-if="isLoading">
    <LoaderComponent />
  </div>
  <div v-else>
    <div class="clock-manager-container">
      <div class="row-clock-container">
        <div v-for="(item, index) in filteredClocks" :key="index">
          <div v-if="item.status" class="row-clock">
            <img class="arrow-icon" src="@assets/icons/green-arrow.png" />
            <div class="row-clock-details">
              <div class="clock-time">{{ getTime(item) }}</div>
              <div class="clock-type">Check-in</div>
            </div>
          </div>
          <div v-else class="row-clock">
            <img class="arrow-icon" src="@assets/icons/red-arrow.png" />
            <div class="row-clock-details">
              <div class="clock-time">{{ getTime(item) }}</div>
              <div class="clock-type">Check-out</div>
            </div>
          </div>
        </div>
      </div>
      <div v-if="filteredClocks.length === 0" class="center">No Check-in yet</div>
      <div class="center">
        <button class="btn-primary" @click="handleCreateClock">Clock</button>
      </div>
    </div>
  </div>
</template>

<style src="./ClockManager.css" />
<script setup>
import { computed, onMounted } from 'vue'
import LoaderComponent from '@components/Loader/LoaderComponent.vue'
import { useClockStore } from '@store/Clock/ClockStore.js'

const props = defineProps({
  userId: {
    type: [String, Number],
    required: true
  }
})

const clockStore = useClockStore()

const clocks = computed(() => clockStore.clocks)
const isLoading = computed(() => clockStore.isLoading)
const storeError = computed(() => clockStore.error)

const filteredClocks = computed(() => {
  return clocks.value
    .filter((item) => {
      const date = new Date(item.time)
      const dateNow = new Date()
      return (
        date.getFullYear() === dateNow.getFullYear() &&
        date.getMonth() === dateNow.getMonth() &&
        date.getDate() === dateNow.getDate()
      )
    })
    .sort((current, item) => new Date(current.time) - new Date(item.time))
})

const handleCreateClock = async () => {
  const newClockData = {
    time: new Date().toISOString(),
    status: !filteredClocks.value.length
      ? true
      : !filteredClocks.value[filteredClocks.value.length - 1].status,
    userId: props.userId
  }
  await clockStore.createClock(newClockData)
}

const getTime = (item) => {
  const rowDate = new Date(item.time)
  return rowDate.toLocaleTimeString('en-GB', { hour: '2-digit', minute: '2-digit' })
}

onMounted(() => {
  clockStore.loadClocks(props.userId)
})
</script>
