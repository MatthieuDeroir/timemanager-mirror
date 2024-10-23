<template>
  <div id="DayliChart">
    <Doughnut v-if="loaded" :data="chartData" :options="chartOptions" />
  </div>
</template>

<script>
import { ArcElement, Chart as ChartJS, Legend, Title, Tooltip } from 'chart.js'
import { defineComponent } from 'vue'
import { useWorkingTimeStore } from '@store/WorkingTime/WorkingTimeStore.js'
import { Doughnut } from 'vue-chartjs'

// Register Chart.js components
ChartJS.register(Title, Tooltip, Legend, ArcElement)

export default defineComponent({
  name: 'DailyPie',
  components: { Doughnut },
  props: {
    userId: {
      type: [String, Number],
      required: true
    },
    workingTimes: {
      type: Array,
      default: () => []
    }
  },
  data() {
    return {
      loaded: false,
      // Initialize chartData to have the correct structure
      chartData: {
        labels: [],
        datasets: [
          {
            label: '',
            backgroundColor: [],
            data: []
          }
        ]
      },
      error: null
    }
  },
  async mounted() {
    this.loaded = false

    const formatDateToISO = (date) => {
      return date.toISOString().slice(0, 19) + 'Z' // Trim milliseconds and add 'Z' for UTC
    }
    //init Date 
    let dayStart = new Date()
    let dayEnd = new Date()
    dayStart.setHours(0, 0, 0, 0)
    dayEnd.setHours(23, 59, 59, 59)
    dayEnd = formatDateToISO(dayEnd)
    dayStart = formatDateToISO(dayStart)

    const startDate = dayStart
    const endDate = dayEnd 

    const workingTimeStore = useWorkingTimeStore()
    await workingTimeStore.loadWorkingTimes(this.userId, startDate, endDate)
    const workingTimes = workingTimeStore.workingTimes

    // Calculate total hours worked per day
    const totalHoursByDay = this.calculateTotalHoursByDay(workingTimes)
      
    // Prepare the chart data
    this.chartData = this.createChartData(totalHoursByDay)
    this.loaded = true
  
    this.loaded = true
  },
  methods: {
    calculateTotalHoursByDay(workingTimes) {
      const totalHours = {}

      workingTimes.forEach((time) => {
        const start = new Date(time.start)
        const end = new Date(time.end)
        const dateKey = start.toLocaleDateString() 
        const hoursWorked = (end - start) / (1000 * 60 * 60) // Convert ms to hours

        if (totalHours[dateKey]) {
          totalHours[dateKey] += hoursWorked
        } else {
          totalHours[dateKey] = hoursWorked
        }
      })

      return totalHours
    },

    createChartData(totalHoursByDay) {

      const labels = ['worked hours'] 
      const data = Object.values(totalHoursByDay) 

      const decimalHoursToPourentage = (decimalHours, referenceHours = 8) => {
        const pourcentageHours = (decimalHours / referenceHours) * 100
        return pourcentageHours.toFixed(2)
      }
      const dataPourcentage = decimalHoursToPourentage(data)
      const dataPourcentageOver = dataPourcentage % 100
      const dataOver = (dataPourcentageOver * 8) / 100
      const quotientDataPourcentage = Math.floor(dataPourcentage / 100)
      const prepareDataset = []
 

      if (quotientDataPourcentage>0){
        if (quotientDataPourcentage >= 1) {
        for (let i = 0; i < quotientDataPourcentage; i++) {
          console.log('i:' + i)
          prepareDataset.push({
            label: 'Work Duration (Hours)',
            backgroundColor: ['#03a10e', '#aaaaaa'],
            data: [8, 0]
          })
          labels.push('overtime')
        }
      }
      prepareDataset.push({
        label: 'Work Duration (Hours)',
        backgroundColor: ['#ff9500', '#aaaaaa'],
        data: [dataOver, 8 - dataOver,]
      })}
      else{
        prepareDataset.push({
        label: 'Work Duration (Hours)',
        backgroundColor: ['#03a10e', '#aaaaaa'],
        data: [dataOver, 8 - dataOver,]
      })
      }

      // Ensure that chartData has labels and datasets
      return {
        labels,
        datasets: prepareDataset
      }
    }
  },
  computed: {
    chartOptions() {
      return {
        responsive: true,
        plugins: {
          legend: {
            position: 'top',
            labels: {
              color: '#f87979',
              text: 'work Duration'
            }
          },
          title: {
            display: true,
            text: 'Daily Work Duration'
          }
        }
      }
    }
  }
})
</script>

<style scoped src="./DayliChart.css"></style>