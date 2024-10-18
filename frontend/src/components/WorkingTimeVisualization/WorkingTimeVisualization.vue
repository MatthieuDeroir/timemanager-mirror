<template>
  <div v-if="loading">
    <LoaderComponent class="loader" />
  </div>

  <div v-else>
    <v-row>
      <v-col cols="6">
        <input
          id="startDate"
          v-model="startDate"
          :max="new Date().toISOString().split('T')[0]"
          type="date"
          @change="onDateRangeChange"
        />
      </v-col>
      <v-col cols="6">
        <input id="endDate" v-model="endDate" disabled type="date" />
      </v-col>
    </v-row>
    <div v-if="workingTimes" class="chart">
      <Bar :data="chartData" :options="chartOptions" />
    </div>
  </div>
</template>

<script setup>
import { onMounted, ref, watch } from 'vue'
import { Bar } from 'vue-chartjs'
import {
  BarElement,
  CategoryScale,
  Chart as ChartJS,
  Legend,
  LinearScale,
  Title,
  Tooltip
} from 'chart.js'
import LoaderComponent from '@components/Loader/LoaderComponent.vue'
import 'vuetify/styles'
import { useWorkingTimeStore } from '@store/WorkingTime/WorkingTimeStore.js'

const workingTimesStore = useWorkingTimeStore()

ChartJS.register(CategoryScale, LinearScale, BarElement, Title, Tooltip, Legend)

/**
 * Get the Monday of the current week,
 * based on the current date.
 * @returns {string}
 */
const getMondayOfCurrentWeek = () => {
  const today = new Date()
  const day = today.getDay()
  const diff = today.getDate() - day + (day === 0 ? -6 : 1)
  const monday = new Date(today.setDate(diff))
  return monday.toISOString().split('T')[0]
}

const workingTimes = ref([])
const loading = ref(true)
const startDate = ref(getMondayOfCurrentWeek())
const endDate = ref(null)
const chartData = ref({
  labels: [],
  datasets: [
    {
      label: 'Normal Hours Worked',
      backgroundColor: '#34c433',
      data: []
    },
    {
      label: 'Overtime Hours',
      backgroundColor: '#ff4b4b',
      data: []
    }
  ]
})

const chartOptions = ref({
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: {
      display: true,
      position: 'right'
    }
  },
  scales: {
    x: {
      stacked: true
    },
    y: {
      stacked: true
    }
  }
})

const props = defineProps({
  userId: {
    type: [String, Number],
    required: true
  }
})

/**
 * Fetch working times for the current user,
 * based on the selected date range.
 * If no date range is selected, the current week is used.
 * If the user changes, the working times are refetched.
 * If the user selects a new date range, the working times are refetched.
 * @returns {Promise<void>}
 */
const fetchWorkingTimes = async () => {
  loading.value = true

  if (startDate.value) {
    endDate.value = calculateEndDate(startDate.value)
    await workingTimesStore.loadWorkingTimes(
      props.userId,
      formatStartDate(startDate.value),
      formatEndDate(endDate.value)
    )
    // const workingTimesData = await getWorkingTimesByUserId(
    //   props.userId,
    //   formatStartDate(startDate.value),
    //   formatEndDate(endDate.value)
    // )
    applyDateRangeFilter(workingTimesStore.workingTimes)
    loading.value = false
  }
}

/**
 * Calculate the end date of the week,
 * based on the start date (Monday).
 * The end date is the following Sunday.
 * The date is formatted as a string.
 * @param start
 * @returns {string}
 */
const calculateEndDate = (start) => {
  const startDate = new Date(start)
  const endDate = new Date(startDate)
  endDate.setDate(startDate.getDate() + 6)
  return endDate.toISOString().split('T')[0]
}

/**
 * Filter the date input to only allow Mondays.
 * @param date
 * @returns {boolean}
 */
const filterMonday = (date) => {
  const day = new Date(date).getDay()
  return day === 1
}

/**
 * Calculate the total hours worked by day,
 * based on the working times.
 * The total hours are split into regular hours and overtime.
 * The regular hours are capped at 7 hours per day.
 * The overtime is calculated as the difference between the total hours and the regular hours.
 * @param workingTimes
 * @returns {{totalHoursByDay: {}, overtimeByDay: {}, regularHoursByDay: {}}}
 */
const calculateTotalHoursByDayWithDate = (workingTimes) => {
  const totalHoursByDay = {}
  const overtimeByDay = {}
  const regularHoursByDay = {}
  const regularWorkingHours = 7

  const defaultDates = Array.from({ length: 7 }, (_, i) => {
    const date = new Date(startDate.value)
    date.setDate(date.getDate() + i)
    return date.toLocaleDateString('fr-FR')
  })

  defaultDates.forEach((date) => {
    totalHoursByDay[date] = 0
    regularHoursByDay[date] = 0
    overtimeByDay[date] = 0
  })

  workingTimes.forEach((workingTime) => {
    const start = new Date(workingTime.start)
    const end = new Date(workingTime.end)
    const day = start.toLocaleDateString('fr-FR')

    const workedHours = (end - start) / (1000 * 60 * 60)

    if (!totalHoursByDay[day]) {
      totalHoursByDay[day] = 0
    }
    totalHoursByDay[day] += workedHours

    regularHoursByDay[day] = Math.min(totalHoursByDay[day], regularWorkingHours)
    overtimeByDay[day] = Math.max(totalHoursByDay[day] - regularWorkingHours, 0)
  })

  chartData.value.labels = defaultDates
  chartData.value.datasets[0].data = defaultDates.map((day) => regularHoursByDay[day] || 0)
  chartData.value.datasets[1].data = defaultDates.map((day) => overtimeByDay[day] || 0)

  return { totalHoursByDay, overtimeByDay, regularHoursByDay }
}

const applyDateRangeFilter = (workingTimes) => {
  calculateTotalHoursByDayWithDate(workingTimes)
}

const onDateRangeChange = () => {
  fetchWorkingTimes()
}

const formatStartDate = (date) => {
  return `${date} 00:00:00`
}

const formatEndDate = (date) => {
  return `${date} 23:59:59`
}

onMounted(() => {
  fetchWorkingTimes()
})

watch(
  () => props.userId,
  () => {
    fetchWorkingTimes()
  }
)
</script>

<style scoped>
.chart {
  height: 400px;
}
</style>