<script setup>
import {ref} from 'vue';
import WorkingTimeManager from '@/components/WorkingTimeManager/WorkingTimeManager.vue';
import WorkingTimeVisualization from '../components/WorkingTimeVisualization/WorkingTimeVisualization.vue';
import ClockManager from '../components/ClockManager/ClockManager.vue';
import UserComponent from '../components/UserSearch/UserSearch.vue';
import CardComponent from '../components/Card/Card.vue';
// Used to store the working times
const workingTimes = ref([]);

/**
 * Method used to update the working times
 * @param updatedTimes
 */
const updateWorkingTimes = (updatedTimes) => {
  workingTimes.value = updatedTimes;
};

</script>

<template>
  <v-container>
    <v-row>
      <v-col cols="12" md="3">
        <CardComponent title="User Info" subtitle="Find user">
          <UserComponent/>
        </CardComponent>
      </v-col>
      <v-col cols="12" md="9">
        <CardComponent title="Working Time Visualization" subtitle="Working time">
          <WorkingTimeVisualization :userId="1" :workingTimes="workingTimes"/>
        </CardComponent>
      </v-col>
      <v-col cols="12" md="3">
        <CardComponent title="Clock Manager" subtitle="Clock">
          <ClockManager/>
        </CardComponent>
      </v-col>
      <v-col cols="12" md="9">
        <CardComponent title="Working Time Manager" subtitle="Manager">
          <WorkingTimeManager :userId="1" @workingTimesUpdated="updateWorkingTimes"/>
        </CardComponent>
      </v-col>
    </v-row>
  </v-container>
</template>


<style src="./HomeView.css" scoped></style>
