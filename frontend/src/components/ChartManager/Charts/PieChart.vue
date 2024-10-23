<template>
    <div class="chart">
      <canvas ref="canvas"></canvas>
    </div>
  </template>
  
  <script>
  import { Pie } from 'vue-chartjs';
  
  export default {
    name: 'PieChart',
    extends: Pie,
    props: ['chartData'],
    watch: {
      chartData(newData) {
        if (newData) {
          this.renderChart(newData, this.options);
        }
      },
    },
    data() {
      return {
        options: {
          responsive: true,
          maintainAspectRatio: false,
        },
      };
    },
    mounted() {
      if (this.chartData) {
        this.renderChart(this.chartData, this.options);
      }
    },
  };
  </script>
  