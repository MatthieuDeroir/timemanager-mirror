<template>
    <div id="DayliChart">

      <DoughnutChart v-if="loaded" />
    </div>

</template>

<script>
import DoughnutChart from './DoughnutChart.vue';
import DoughnutChartOver from './DoughnutChartOver.vue';
import { Chart as ChartJS, Title, Tooltip, Legend, ArcElement } from 'chart.js';
import { ref, defineComponent } from 'vue';
import { getWorkingTimesByUserId } from '@services/workingtimeServices.js';

// Register Chart.js components
ChartJS.register(Title, Tooltip, Legend, ArcElement);

export default defineComponent({
  name: 'DailyPie',
  components: {  DoughnutChartOver, DoughnutChart },
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
            label: 'Work Duration (Hours)',
            backgroundColor: ['#f87979', '#7C4DFF', '#FFCA28', '#66BB6A'],
            data: [],
          },
        ],
      },
      error: null,
    };
  },
  async mounted() {
    this.loaded = false;
    const startDate = ref(null); // Optional: can be passed from parent or a filter
    const endDate = ref(null); // Optional: same as above

    try {
      // Fetch the working times by userId
      const workingTimes =
        this.workingTimes.length > 0
          ? this.workingTimes
          : await getWorkingTimesByUserId(this.userId, startDate.value, endDate.value);

      // Calculate total hours worked per day
      const totalHoursByDay = this.calculateTotalHoursByDay(workingTimes);

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
        // console.log("dateKey"+dateKey);
        
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
      const labels = Object.keys(totalHoursByDay); // Dates

      const data = Object.values(totalHoursByDay); // Hours worked
    //   console.log("labels:"+labels);
      console.log("data:"+data);
      console.log("data %:"+((data*8)/100))
      
      if (data>100) console.log("modulo data"+((data*8)/100)%100)
     
    //   console.log("time%"+((28*8)/100))   
    //   console.log("modulo time%"+((28*8)/100)%100)
    //   console.log("many turn"+(((28*8)/100)-((28*8)/100)%100));
      
      console.log("many turn"+(((data*8)/100)-((data*8)/100)%100));
      console.log("555"+new Date())
      

      // Ensure that chartData has labels and datasets
      return {
        labels,
        datasets: [
          {
            label: 'Work Duration (Hours)',
            backgroundColor: ['#f87979', '#7C4DFF'],
            data:[data, 1000],
          },
        ],
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

