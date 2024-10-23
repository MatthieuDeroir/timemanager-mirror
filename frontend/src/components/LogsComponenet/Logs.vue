<template>
  <div class="logs">
    <div v-if="logsError">{{ logsError }}</div>  
    <div v-if="logsLoading"> <Loader></Loader></div>
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
              <div class="username-info">
                (id: {{ log.user.id }})
              </div>
            </div>
            <span class="action">{{ log.action }}</span>
            <span class="message">{{ log.message || 'N/A' }}</span>
            <span class="date">{{ formatDate(log.timestamp) }}</span>
            <span class="team">
              <div v-if="log.user.teams.length > 0">
                <div class="team-info">
                  {{ log.user.teams[0].name }} 
                </div>
                <div class="team-info">
                  (id: {{ log.user.teams[0].id }})
                </div>
              </div>
              <div v-else>
                No Team
              </div>
            </span>
          </div>
          <hr />
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { ref, onMounted } from 'vue';
import Loader from '@components/Loader/LoaderComponent.vue';

const mockedLogs = [
  {
    action: "Create user information",
    message: "",
    user: {
      id: 11,
      username: "liam.garcia",
      role: {
        id: 1,
        name: "admin"
      },
      teams: [{
        id: 3,
        name: "IT"
      }]
    },
    timestamp: "2024-10-01T10:00:00Z"
  },
  {
    action: "Update user information",
    message: "",
    user: {
      id: 11,
      username: "liam.garcia",
      role: {
        id: 1,
        name: "admin"
      },
      teams: [{
        id: 3,
        name: "IT"
      }]
    },
    timestamp: "2024-10-02T11:00:00Z"
  },
  {
    action: "Create team Kaputeam",
    message: "",
    user: {
      id: 10,
      username: "jack.wilson",
      role: {
        id: 2,
        name: "general manager"
      },
      teams: [{
        id: 1,
        name: "Accountability"
      }]
    },
    timestamp: "2024-10-03T12:00:00Z"
  },
  {
    action: "Add user 9 to Kaputeam",
    message: "",
    user: {
      id: 10,
      username: "jack.wilson",
      role: {
        id: 2,
        name: "general manager"
      },
      teams: [{
        id: 1,
        name: "Accountability"
      }]
    },
    timestamp: "2024-10-04T13:00:00Z"
  },
  {
    action: "Add user 8 to Kaputeam",
    message: "",
    user: {
      id: 9,
      username: "isabella.taylor",
      role: {
        id: 3,
        name: "manager"
      },
      teams: [
        {
          id: 4,
          name: "Kaputeam"
        }
      ]
    },
    timestamp: "2024-10-05T14:00:00Z"
  },
  {
    action: "Clocked in",
    message: "",
    user: {
      id: 8,
      username: "henry.lee",
      role: {
        id: 4,
        name: "employee"
      },
      teams: [
        {
          id: 4,
          name: "Kaputeam"
        }
      ]
    },
    timestamp: "2024-10-06T15:00:00Z"
  },
  {
    action: "Clocked out",
    message: "",
    user: {
      id: 8,
      username: "henry.lee",
      role: {
        id: 4,
        name: "employee"
      },
      teams: [
        {
          id: 4,
          name: "Kaputeam"
        }
      ]
    },
    timestamp: "2024-10-06T16:00:00Z"
  }
];

const logs = ref(mockedLogs);
const logsLoading = ref(false);
const logsError = ref(null);

onMounted(() => {
  logsLoading.value = true;
  setTimeout(() => {
    logsLoading.value = false;
  }, 1000);
});

const formatDate = (timestamp) => {
  return new Date(timestamp).toLocaleString();
};
</script>

<style scoped>
.logs {
  padding: 20px;
}

.chartheader {
  display: flex;
  justify-content: space-between;
  font-weight: bold;
  margin-bottom: 10px;
}

.header {
  width: 150px;
}

.log-entry {
  display: flex;
  justify-content: space-between;
  margin-bottom: 10px;
  text-wrap: wrap;
}

.role, .action, .message, .date, .team {
  width: 150px;
}

.username {
  display: flex;
  flex-direction: column;
  width: 150px;
}

.team-info {
  display: flex;
  flex-direction: column;
  width: 150px;
}

.username-info, .team-info {
  margin: 0;
}
</style>
