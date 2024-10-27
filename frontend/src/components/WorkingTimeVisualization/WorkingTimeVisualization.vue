<template>
  <div v-if="workingTimeStore.isLoading">
    <LoaderComponent class="loader" />
  </div>
  <div v-else>
    <v-row class="date-range-picker">
      <v-col cols="6">
        <input
          id="startDate"
          v-model="workingTimeStore.startDate"
          :max="maxDate"
          type="date"
          @change="workingTimeStore.loadWorkingTimesForDateRange(userId)"
        />
      </v-col>
      <v-col cols="6">
        <input id="endDate" v-model="workingTimeStore.endDate" disabled type="date" />
      </v-col>
    </v-row>
    <div v-if="hasWorkingTimes" class="chart">
      <Bar :data="chartData" :options="chartOptions" />
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted, watch } from 'vue'
import { Bar } from 'vue-chartjs'
import LoaderComponent from '@components/Loader/LoaderComponent.vue'
import { useWorkingTimeStore } from '@store/WorkingTime/WorkingTimeStore.js'
import {
  BarElement,
  CategoryScale,
  Chart as ChartJS,
  Legend,
  LinearScale,
  Title,
  Tooltip
} from 'chart.js'

ChartJS.register(CategoryScale, LinearScale, BarElement, Title, Tooltip, Legend)

const workingTimeStore = useWorkingTimeStore()

// Props
const props = defineProps({
  userId: {
    type: [String, Number],
    required: true
  }
})

// Computed Properties
const maxDate = computed(() => new Date().toISOString().split('T')[0])
const hasWorkingTimes = computed(() => workingTimeStore.workingTimesByDay.defaultDates?.length > 0)

// Chart Data
const chartData = computed(() => ({
  labels: workingTimeStore.workingTimesByDay.defaultDates,
  datasets: [
    {
      label: 'Normal Hours Worked',
      backgroundColor: '#34c433',
      data: workingTimeStore.workingTimesByDay.regularHoursByDay
    },
    {
      label: 'Overtime Hours',
      backgroundColor: '#ff4b4b',
      data: workingTimeStore.workingTimesByDay.overtimeByDay
    }
  ]
}))

const chartOptions = {
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: { display: true, position: 'right' }
  },
  scales: { x: { stacked: true }, y: { stacked: true } }
}

onMounted(() => {
  workingTimeStore.loadWorkingTimesForDateRange(props.userId)
})
// Watch userId to reload data
watch(
  () => props.userId,
  () => workingTimeStore.loadWorkingTimesForDateRange(props.userId)
)
</script>
