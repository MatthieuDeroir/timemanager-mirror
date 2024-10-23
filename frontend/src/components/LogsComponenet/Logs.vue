<template>
  <div class="logs">
    <div v-if="logsError">{{ logsError }}</div>
    <div v-if="logsLoading"><Loader /></div>
    <div v-else>
      <div>
        <div class="chartheader">
          <span class="header">Level of authority</span>
          <span class="header">Username</span>
          <span class="header">Action</span>
          <span class="header">Message</span>
          <span class="header">Date</span>
          <span class="header">Team</span>
        </div>
        <hr />
      </div>

      <div v-if="logs.length === 0">
        <p>No logs available.</p>
      </div>

      <div v-else>
        <div v-for="log in logs" :key="log.user.id + log.action">
          <div class="log-entry">
            <span class="role">{{ log.user.role.name }}</span>
            <div class="username">
              <div class="username-info">
                {{ log.user.username }}
              </div>
              <div class="username-info">(id: {{ log.user.id }})</div>
            </div>
            <span class="action">{{ log.action }}</span>
            <span class="message">{{ log.message || 'N/A' }}</span>
            <span class="date">{{ formatDate(log.timestamp) }}</span>
            <span class="team">
              <div v-if="log.user.teams.length > 0">
                <div class="team-info">
                  {{ log.user.teams[0].name }}
                </div>
                <div class="team-info">(id: {{ log.user.teams[0].id }})</div>
              </div>
              <div v-else>No Team</div>
            </span>
          </div>
          <hr />
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { ref, onMounted, watch } from 'vue'
import Loader from '@components/Loader/LoaderComponent.vue'
import { useLogsStore } from '@store/LogsStore/LogsStore.js'

const logsStore = useLogsStore()
const logs = ref(logsStore.logs)
const logsLoading = ref(logsStore.isLoading)
const logsError = ref(logsStore.error)

onMounted(async () => {
  await logsStore.loadAllLogs()
})

watch(
  () => logsStore.logs,
  (newLogs) => {
    logs.value = newLogs
  }
)

const formatDate = (timestamp) => {
  return new Date(timestamp).toLocaleString()
}
</script>

<style scoped src="./Logs.css"></style>
