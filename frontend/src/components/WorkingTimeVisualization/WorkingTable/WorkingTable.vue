<!-- WorkingTimeTable.vue -->
<template>
    <div>
      <table>
        <thead>
          <tr>
            <th>Date</th>
            <th>Heures totales</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(hours, day) in totalHoursByDay" :key="day">
            <td>{{ day }}</td>
            <td>{{ hours.toFixed(2) }} heures</td>
          </tr>
        </tbody>
      </table>
    </div>
  </template>
  
  <script>
  export default {
    props: {
      totalHoursByDay: {
        type: Object,
        required: true // Les heures totales par jour sont obligatoires
      }
    }
  }
  </script>
  
  <style scoped>
  table {
    width: 100%;
    border-collapse: collapse;
  }
  th, td {
    padding: 8px;
    border: 1px solid #ddd;
    text-align: left;
  }
  </style>
  