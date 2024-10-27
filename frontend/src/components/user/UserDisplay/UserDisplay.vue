<template>
  <div v-if="loading">
    <LoaderComponent></LoaderComponent>
  </div>
  <div v-else class="user-tile">
    <div class="category">
      <div class="title">Employee</div>
      <div class="infos">
        <div class="label">Username:</div>
        <div v-if="editStatus">
          <input v-model="user.username" class="input-text" type="text" />
        </div>
        <div v-else>
          <div>{{ user.username }}</div>
        </div>
      </div>

      <div v-if="editStatus">
        <div class="infos">
          <div class="label">Firstname:</div>
          <div>
            <input v-model="user.firstname" class="input-text" type="text" />
          </div>
        </div>
      </div>

      <div v-if="editStatus">
        <div class="infos">
          <div class="label">Lastname:</div>
          <div>
            <input v-model="user.lastname" class="input-text" type="text" />
          </div>
        </div>
      </div>

      <div v-if="editStatus">
        <div class="infos">
          <div class="label">Email:</div>
          <div>
            <input v-model="user.email" class="input-text" type="text" />
          </div>
        </div>
      </div>

      <div v-if="editStatus">
        <div class="infos">
          <div class="label">Gender:</div>
          <div>
            <input v-model="user.gender" class="input-text" type="text" />
          </div>
        </div>
      </div>

      <div class="infos">
        <div class="label">Birthdate:</div>
        <div v-if="editStatus">
          <input v-model="user.birthdate" class="input-date" type="date" />
        </div>
        <div v-else>
          <div>{{ user.birthdate }}</div>
        </div>
      </div>

      <div class="infos">
        <div class="label">Phone:</div>
        <div v-if="editStatus">
          <input v-model="user.phone" class="input-text" type="text" />
        </div>
        <div v-else>
          <div>{{ user.phone }}</div>
        </div>
      </div>

      <div class="infos">
        <div class="label">Address:</div>
        <div v-if="editStatus">
          <input v-model="user.address" class="input-text" type="text" />
        </div>
        <div v-else>
          <div>{{ user.address }}</div>
        </div>
      </div>
    </div>
    <div class="category">
      <div class="title">Contract</div>
      <div class="infos">
        <div class="label">Salary:</div>
        <div v-if="editStatus">
          <input v-model="user.salary" class="input-number" type="number" />
        </div>
        <div v-else>
          <div>{{ user.salary ?? 0 }} hints/month</div>
        </div>
      </div>
      <div class="infos">
        <div class="label">Position:</div>
        <div v-if="editStatus">
          <input v-model="user.position" class="input-text" type="text" />
        </div>
        <div v-else>
          <div>{{ user.position }}</div>
        </div>
      </div>
      <div class="infos">
        <div class="label">Start Date:</div>
        <div v-if="editStatus">
          <input v-model="user.start_date" class="input-date" type="date" />
        </div>
        <div v-else>
          <div>{{ user.start_date }}</div>
        </div>
      </div>
      <div class="infos">
        <div class="label">End Date:</div>
        <div v-if="editStatus">
          <input v-model="user.end_date" class="input-date" type="date" />
        </div>
        <div v-else>
          <div>{{ user.end_date }}</div>
        </div>
      </div>
      <div class="infos">
        <div class="label">Team:</div>
        <div>
          <div v-for="team in user.teams">
            {{ team.name.charAt(0).toUpperCase() + team.name.slice(1) }}
          </div>
        </div>
      </div>
      <div class="infos">
        <div class="label">Role:</div>
        <div v-if="editStatus">
          <input v-model="user.role_id" class="input-number" type="number" />
        </div>
        <div v-else>
          <div>{{ getRoleName(user.role_id) }}</div>
        </div>
      </div>
    </div>
    <div v-if="authStore.user?.role_id !== UserRole.EMPLOYEE" class="user-edit">
      <div v-if="deleteStatus">
        <svg
          height="30px"
          viewBox="0 0 48 48"
          width="30px"
          xmlns="http://www.w3.org/2000/svg"
          @click="handleDeleteStatus"
        >
          <path
            d="M19.5,11.5V10c0-2.5,2-4.5,4.5-4.5s4.5,2,4.5,4.5v1.5"
            fill="none"
            stroke="#FFF"
            stroke-miterlimit="10"
            stroke-width="3"
          />
          <line
            fill="none"
            stroke="#FFF"
            stroke-linecap="round"
            stroke-miterlimit="10"
            stroke-width="3"
            x1="8.5"
            x2="39.5"
            y1="11.5"
            y2="11.5"
          />
          <line
            fill="none"
            stroke="#FFF"
            stroke-linecap="round"
            stroke-miterlimit="10"
            stroke-width="3"
            x1="36.5"
            x2="36.5"
            y1="23.5"
            y2="11.5"
          />
          <path
            d="M11.5,18.7v19.8c0,2.2,1.8,4,4,4h17c2.2,0,4-1.8,4-4V31"
            fill="none"
            stroke="#FFF"
            stroke-linecap="round"
            stroke-miterlimit="10"
            stroke-width="3"
          />
          <line
            fill="none"
            stroke="#FFF"
            stroke-linecap="round"
            stroke-miterlimit="10"
            stroke-width="3"
            x1="20.5"
            x2="20.5"
            y1="19.5"
            y2="34.5"
          />
          <line
            fill="none"
            stroke="#FFF"
            stroke-linecap="round"
            stroke-miterlimit="10"
            stroke-width="3"
            x1="27.5"
            x2="27.5"
            y1="19.5"
            y2="34.5"
          />
        </svg>
      </div>
      <div v-else>
        <button class="btn-primary" @click="handleDelete(userId)">delete</button>
        <button class="btn-danger" @click="handleDeleteStatus">cancel</button>
      </div>
      <div v-if="editStatus" class="user-edit-buttons">
        <button class="btn-primary" @click="handleSaveEdit">Save</button>
        <button class="btn-danger" @click="handleCancelEdit">Cancel</button>
      </div>
      <div v-else>
        <svg
          class="edit-icon"
          viewBox="0 0 24 24"
          xmlns="http://www.w3.org/2000/svg"
          @click="handleTurnOnEdit"
        >
          <path
            d="M5,3C3.89,3 3,3.89 3,5V19A2,2 0 0,0 5,21H19A2,2 0 0,0 21,19V12H19V19H5V5H12V3H5M17.78,4C17.61,4 17.43,4.07 17.3,4.2L16.08,5.41L18.58,7.91L19.8,6.7C20.06,6.44 20.06,6 19.8,5.75L18.25,4.2C18.12,4.07 17.95,4 17.78,4M15.37,6.12L8,13.5V16H10.5L17.87,8.62L15.37,6.12Z"
          />
        </svg>
      </div>
    </div>
  </div>
</template>
<style src="./UserDisplay.css"></style>
<script setup>
import { onMounted, ref, watch } from 'vue'
import LoaderComponent from '@components/Loader/LoaderComponent.vue'
import { getUserById } from '@/api/UserAPI.js'
import { useUserStore } from '@store/User/UserStore.js'
import { useAuthStore } from '@store/Auth/AuthStore'
import { UserRole } from '@enum/User/UserRole'
import { getRoleName } from '@utils/utils'

const props = defineProps({
  userId: {
    type: Number,
    required: true
  }
})

const loading = ref({})
const editStatus = ref(false)
const deleteStatus = ref(true)
const user = ref({})
const emit = defineEmits(['selecteduser'])
const userStore = useUserStore()
const authStore = useAuthStore()

const fetchUser = async (userId) => {
  user.value = await getUserById(userId)
  user.value.birthdate = new Date(user.value.birthdate).toLocaleDateString('en-GB', {
    day: '2-digit',
    month: 'long',
    year: 'numeric'
  })
  user.value.start_date = new Date(user.value.start_date).toLocaleDateString('en-GB', {
    day: '2-digit',
    month: 'long',
    year: 'numeric'
  })
  user.value.end_date = new Date(user.value.end_date).toLocaleDateString('en-GB', {
    day: '2-digit',
    month: 'long',
    year: 'numeric'
  })
  loading.value = false
  emit('selecteduser', user.value)
}
const handleDeleteStatus = () => {
  deleteStatus.value = !deleteStatus.value
  editStatus.value = false
}
const handleDelete = async (userId) => {
  await userStore.deleteUser(userId)
}

const handleTurnOnEdit = () => {
  editStatus.value = true
  deleteStatus.value = true
}
const handleSaveEdit = async () => {
  loading.value = true

  try {
    user.value.birthdate = new Date(user.value.birthdate).toISOString().split('T')[0]
    user.value.start_date = new Date(user.value.start_date).toISOString().split('T')[0]
    user.value.end_date = new Date(user.value.end_date).toISOString().split('T')[0]

    await userStore.updateUser(user.value.id, { user: user.value })

    user.value.birthdate = new Date(user.value.birthdate).toLocaleDateString('en-GB', {
      day: '2-digit',
      month: 'long',
      year: 'numeric'
    })
    user.value.start_date = new Date(user.value.start_date).toLocaleDateString('en-GB', {
      day: '2-digit',
      month: 'long',
      year: 'numeric'
    })
    user.value.end_date = new Date(user.value.end_date).toLocaleDateString('en-GB', {
      day: '2-digit',
      month: 'long',
      year: 'numeric'
    })

    editStatus.value = false
  } catch (error) {
    console.error('Error updating user: ', error)
  } finally {
    loading.value = false
  }
}

const handleCancelEdit = () => {
  editStatus.value = false
  deleteStatus.value = true
  fetchUser(props.userId)
}
onMounted(() => {
  loading.value = true
  fetchUser(props.userId)
})

watch(
  () => props.userId,
  (newUserId) => {
    fetchUser(newUserId)
  }
)

const editUser = () => {
  console.log('Modifier l’utilisateur')
}

const deleteUser = () => {
  console.log('Supprimer l’utilisateur')
}
</script>
