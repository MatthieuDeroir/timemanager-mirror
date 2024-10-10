<script setup>
import WorkingTimeManager from '@/components/WorkingTimeManager/WorkingTimeManager.vue';
import WorkingTimeVisualization from '../components/WorkingTimeVisualization/WorkingTimeVisualization.vue'
</script>

<template>
  <main>
    <WorkingTimeVisualization :userId="1" />
    <WorkingTimeManager :userId="1" />
  </main>
</template>
