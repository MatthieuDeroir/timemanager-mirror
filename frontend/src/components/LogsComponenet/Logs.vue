<template>
  <div class="logs">
    <div v-if="logsStore.isLoading">
      <Loader />
    </div>
    <div v-else>
      <div>
        <div class="chartheader">
          <span class="header">Level of Authority</span>
          <span class="header">Username</span>
          <span class="header">Action</span>
        </div>
        <hr />
      </div>

      <div v-if="logsStore.logs.length === 0">
        <p>No logs available.</p>
      </div>

      <div v-else>
        <div v-for="(log, index) in logsStore.logs.logs" :key="index" class="log-entry">
          <span class="role">{{ log?.user?.role?.name || 'No Role' }}</span>
          <div class="username">
            <div class="username-info">{{ log?.user?.username || 'No Username' }}</div>
          </div>
          <span class="action">{{ log?.message || 'No Action' }}</span>
        </div>

        <hr />
      </div>

      <!-- Pagination Button -->
      <div class="pagination">
        <button :disabled="logsStore.isLoading || page.value === 1" @click="loadPreviousLogs">
          Page Précédente
        </button>
        <button :disabled="logsStore.isLoading" @click="loadMoreLogs">Page Suivante</button>
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { onMounted, ref, watch } from 'vue'
import Loader from '@components/Loader/LoaderComponent.vue'
import { useLogsStore } from '@store/LogsStore/LogsStore.js'

const props = defineProps({
  userId: {
    type: [String, Number],
    required: true
  }
})

const logsStore = useLogsStore()

const page = ref(1)
const pageSize = 10

const loadLogs = async () => {
  await logsStore.loadAllLogsByUserId(props.userId, page.value, pageSize)
}

/**
 * Method used to load more logs
 */
const loadMoreLogs = () => {
  page.value += 1
  loadLogs()
}

/**
 * Method used to load the previous logs
 */
const loadPreviousLogs = () => {
  if (page.value > 1) {
    page.value -= 1
    loadLogs()
  }
}

onMounted(loadLogs)

watch(
  () => props.userId,
  () => logsStore.loadAllLogsByUserId(props.userId, page.value, pageSize)
)
</script>

<style scoped src="./Logs.css"></style>
