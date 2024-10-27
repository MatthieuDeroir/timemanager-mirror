<template>
  <div class="chart">
    <canvas ref="canvas"></canvas>
  </div>
</template>

<script>
import { Line } from 'vue-chartjs'

export default {
  name: 'LineChart',
  extends: Line,
  props: ['chartData'],
  watch: {
    chartData(newData) {
      if (newData) {
        this.renderChart(newData, this.options)
      }
    }
  },
  data() {
    return {
      options: {
        responsive: true,
        maintainAspectRatio: false
      }
    }
  },
  mounted() {
    if (this.chartData) {
      this.renderChart(this.chartData, this.options)
    }
  }
}
</script>
