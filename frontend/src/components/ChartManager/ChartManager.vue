<script setup>
import { onMounted, ref } from 'vue';
import { useRoute } from 'vue-router';
import { fetchAndPrepareChartData } from './ChartManager.js';
import BarChart from './Charts/BarChart.vue';
import LineChart from './Charts/LineChart.vue';
import PieChart from './Charts/PieChart.vue';

const route = useRoute();
const barChartData = ref(null);
const lineChartData = ref(null);
const pieChartData = ref(null);

onMounted(async () => {
  const userId = route.params.userid;
  await loadChartData(userId);
});

async function loadChartData(userId) {
  try {
    const chartData = await fetchAndPrepareChartData(userId);
    barChartData.value = chartData.barChartData;
    lineChartData.value = chartData.lineChartData;
    pieChartData.value = chartData.pieChartData;
  } catch (error) {
    console.error('Error loading chart data:', error);
  }
}
</script>

<template>
  <div class="chart-manager">
    <h2>Charts Dashboard</h2>
    <div class="chart-container">
      <BarChart v-if="barChartData" :chart-data="barChartData" />
    </div>
    <div class="chart-container">
      <LineChart v-if="lineChartData" :chart-data="lineChartData" />
    </div>
    <div class="chart-container">
      <PieChart v-if="pieChartData" :chart-data="pieChartData" />
    </div>
  </div>
</template>
  
  <style src="./ChartManager.css"></style>
  