<script setup>
import { ref } from 'vue'
import WorkingTimeManager from '@/components/WorkingTimeManager/WorkingTimeManager.vue'
import WorkingTimeVisualization from '../components/WorkingTimeVisualization/WorkingTimeVisualization.vue'
import ClockManager from '../components/ClockManager/ClockManager.vue'
import UserDisplay from '@components/user/UserDisplay/UserDisplay.vue'
import CardComponent from '../components/Card/Card.vue' // Récupérer l'ID utilisateur depuis les props

// Récupérer l'ID utilisateur depuis les props
const props = defineProps({
  userId: {
    type: Number,
    required: true // Assurez-vous que userId est toujours fourni
  }
})

// Stocker les temps de travail
const workingTimes = ref([])

/**
 * Méthode utilisée pour mettre à jour les temps de travail
 * @param updatedTimes
 */
const updateWorkingTimes = (updatedTimes) => {
  workingTimes.value = updatedTimes
}

// // Charger les données lors du montage initial du composant
// onMounted(() => {
//   fetchData(props.userId);  // Charger les données pour l'ID utilisateur initial
// });

// // Surveiller les changements de userId via les props
// watch(() => props.userId, (newUserId) => {
//   fetchData(newUserId);  // Recharger les données lorsque userId change
// });
//
// // Surveiller les changements de route pour mettre à jour userId
// onBeforeRouteUpdate((to, from, next) => {
//   const newUserId = Number(to.params.userId); // Assurez-vous que userId est un nombre
//   if (newUserId !== props.userId) {
//     fetchData(newUserId);  // Recharger les données si l'ID change
//   }
//   next();
// });
</script>

<template>
  <v-container>
    <v-row>
      <v-col cols="12" md="3">
        <CardComponent subtitle="Find user" title="User Info">
          <UserDisplay :userId="userId" />
        </CardComponent>
      </v-col>

      <v-col cols="12" md="9">
        <CardComponent subtitle="Working time" title="Working Time Visualization">
          <WorkingTimeVisualization :userId="userId" :workingTimes="workingTimes" />
        </CardComponent>
      </v-col>

      <v-col cols="12" md="3">
        <CardComponent subtitle="Clock" title="Clock Manager">
          <ClockManager />
        </CardComponent>
      </v-col>

      <v-col cols="12" md="9">
        <CardComponent subtitle="Manager" title="Working Time Manager">
          <WorkingTimeManager :userId="userId" @workingTimesUpdated="updateWorkingTimes" />
        </CardComponent>
      </v-col>
    </v-row>
  </v-container>
</template>
<style scoped src="./HomeView.css"></style>