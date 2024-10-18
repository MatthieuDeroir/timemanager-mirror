<template>
  <div id="DayliChart">
    <Doughnut v-if="loaded" :data="chartData" :options="chartOptions" />
  </div>

</template>

<script>
// import DoughnutChart from './DoughnutChart.vue';
import { Chart as ChartJS, Title, Tooltip, Legend, ArcElement } from 'chart.js';
import { defineComponent } from 'vue';
import { getWorkingTimesByUserId } from '@services/workingtimeServices.js';
import { Doughnut } from 'vue-chartjs';

// Register Chart.js components
ChartJS.register(Title, Tooltip, Legend, ArcElement);

export default defineComponent({
  name: 'DailyPie',
  components: { Doughnut },
  props: {
    userId: {
      type: [String, Number],
      required: true,
    },
    workingTimes: {
      type: Array,
      default: () => [],
    },
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
            data: [],
          },
        ],
      },
      error: null,
    };
  },
  async mounted() {
    this.loaded = false;

    const formatDateToISO = (date) => {
      return date.toISOString().slice(0, 19) + 'Z'; // Trim milliseconds and add 'Z' for UTC
    }

    let dayStart = new Date()
    dayStart.setHours(0, 0, 0, 0)
    let dayEnd = new Date()
    dayEnd.setHours(23, 59, 59, 59)
    dayEnd = formatDateToISO(dayEnd)
    dayStart = formatDateToISO(dayStart)

    const startDate = dayStart; // Optional: can be passed from parent or a filter
    const endDate = dayEnd; // Optional: same as above

    try {
      // Fetch the working times by userId
      const workingTimes =
        this.workingTimes.length > 0
          ? this.workingTimes
          : await getWorkingTimesByUserId(this.userId, startDate, endDate);
      // Calculate total hours worked per day
      const totalHoursByDay = this.calculateTotalHoursByDay(workingTimes);
      // console.log(workingTimes)
      // console.log(totalHoursByDay)

      // Prepare the chart data
      this.chartData = this.createChartData(totalHoursByDay);
      this.loaded = true;
    } catch (err) {
      this.error = err.message || 'An error occurred while fetching data.';
    }
    this.loaded = true
  },
  methods: {
    calculateTotalHoursByDay(workingTimes) {
      const totalHours = {};

      workingTimes.forEach((time) => {
        const start = new Date(time.start);
        const end = new Date(time.end);
        const dateKey = start.toLocaleDateString(); // Group by date
        const hoursWorked = (end - start) / (1000 * 60 * 60); // Convert ms to hours

        if (totalHours[dateKey]) {
          totalHours[dateKey] += hoursWorked;
        } else {
          totalHours[dateKey] = hoursWorked;
        }
      });

      return totalHours;
    },

    createChartData(totalHoursByDay) {
      // const labels = Object.keys(totalHoursByDay); // Dates
      const labels = ["worked hours"]; // Dates
      const data = Object.values(totalHoursByDay); // Hours worked
      const decimalHoursToPourentage = (decimalHours, referenceHours = 8) => {
        const pourcentageHours = (decimalHours / referenceHours) * 100
        return pourcentageHours.toFixed(2)
      }
      const dataPourcentage = decimalHoursToPourentage(data)
      const dataPourcentageOver = (dataPourcentage) % 100
      const dataOver = (dataPourcentageOver * 8) / 100
      const quotientDataPourcentage = Math.floor(dataPourcentage / 100)
      const prepareDataset = []
      console.log("AAAAAAAAAAA",Object(totalHoursByDay));
      
      // console.log("data:" + data)
      // console.log("data%" + dataPourcentage)
      // console.log("data%over" + dataPourcentageOver)
      // console.log("dataOver", dataOver)
      // console.log("data nb tour:" + quotientDataPourcentage);

      if (quotientDataPourcentage >= 1) {
        for (let i = 0; i < quotientDataPourcentage; i++) {
          console.log("i:" + i);
          prepareDataset.push({
            label: 'Work Duration (Hours)',
            backgroundColor: ['#03a10e', '#aaaaaa'],
            data: [8, 0,]
          })
          labels.push("overtime")
        }
      }
      prepareDataset.push(
        {
          label: 'Work Duration (Hours)',
          backgroundColor: ['#ff9500', '#aaaaaa', '#ffffff'],
          data: [dataOver, 8 - dataOver,0,0]
        }
      )
      console.log("prepareDataset", prepareDataset);
      console.log("prepareDataset[1]", prepareDataset[1]);


      // Ensure that chartData has labels and datasets
      return {
        labels,
        datasets: prepareDataset
      };
    },
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
            text: 'Daily Work Duration',
          },
        },
      };
    },
  },
});
</script>


<style scoped src="./DayliChart.css"></style>
