<!-- WorkingTimeVisualizationManager.vue -->
<script setup>
import { getWorkingTimesByUserId } from '../../services/workingtimeServices'
import WorkingTimeTable from './WorkingTable/WorkingTable.vue'
</script>

<template>
  <div>
    <h2>Visualisation des heures de travail</h2>
    <p v-if="loading">Chargement des données...</p>
    <p v-if="error">{{ error }}</p>
    <WorkingTimeTable v-if="!loading && !error" :totalHoursByDay="totalHoursByDay" />
  </div>
</template>

<script>
import { getWorkingTimesByUserId } from '../../services/workingtimeServices'
import WorkingTimeTable from './WorkingTable/WorkingTable.vue'

export default {
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
      loading: true,
      error: null,
      totalHoursByDay: {}, 
      startDate: null, 
      endDate: null
    }
  },
  methods: {
    /**
     * Retrieve the working times for the user, and calculate the total hours worked by day.
     * @returns {Promise<void>}
     */
    async getWorkingTimes() {
      try {
        this.loading = true;
        this.error = null;

        const workingTimes = this.workingTimes.length > 0
          ? this.workingTimes
          : await getWorkingTimesByUserId(this.userId, this.startDate, this.endDate);

        this.totalHoursByDay = this.calculateTotalHoursByDay(workingTimes);
      } catch (err) {
        this.error = err.message || 'Une erreur est survenue lors de la récupération des données.';
      } finally {
        this.loading = false;
      }
    },

    /**
     * Calculate the total hours worked by day.
     * @param {Array} workingTimes - Array of working times
     * @returns {Object} - Object with the total hours worked by day
     */
    calculateTotalHoursByDay(workingTimes) {
      const totalHoursByDay = {};

      workingTimes.forEach((time) => {
        const startDate = new Date(time.start);
        const endDate = new Date(time.end);
        const dateKey = startDate.toLocaleDateString();
        const hoursWorked = (endDate - startDate) / (1000 * 60 * 60); 

        if (totalHoursByDay[dateKey]) {
          totalHoursByDay[dateKey] += hoursWorked;
        } else {
          totalHoursByDay[dateKey] = hoursWorked;
        }
      });

      return totalHoursByDay;
    }
  },

  mounted() {
    this.getWorkingTimes(); 
  },

  watch: {
    workingTimes: {
      handler(newWorkingTimes) {
        this.totalHoursByDay = this.calculateTotalHoursByDay(newWorkingTimes);
      },
      deep: true,
      immediate: true 
    }
  }
}
</script>