<!-- This component will be changed after we add a data visualization librairy -->
<template>
  <div class="working-times">
    <h2>Overview of the hours worked for User : {{ userId }}</h2>

    <!-- Message de chargement ou d'erreur -->
    <div v-if="loading">Loading...</div>
    <div v-if="error" class="error">Failed to load working times: {{ error }}</div>

    <!-- Tableau des temps de travail par jour -->
    <table v-if="!loading && !error">
      <thead>
        <tr>
          <th>Date</th>
          <th>Total Hours Worked</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(hours, date) in totalHoursByDay" :key="date">
          <td>{{ date }}</td>
          <td>{{ hours }} hours</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script src="./WorkingTimeVisualization.js"></script>
<style src="./WorkingTimeVisualization.css"></style>