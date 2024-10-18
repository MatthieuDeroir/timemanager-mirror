<template>
  <!-- Create a container for expansion panels -->
  <v-expansion-panels>
    <v-expansion-panel v-for="team in getUserTeams()" :key="team.id">
      
      <!-- Panel title is the team name -->
      <v-expansion-panel-title>
        {{ team.name }}
      </v-expansion-panel-title>

      <!-- Panel content (Users in this team) -->
      <v-expansion-panel-text>
        <!-- Filter users by team_id and display each user's details -->
        <div v-for="user in getUsersByTeam(team.id)" :key="user.id">
          <p>User ID: {{ user.id }}</p>
          <p>First Name: {{ user.firstname }}</p>
          <p>Last Name: {{ user.lastname }}</p>
          <p>Email: {{ user.email }}</p>
          <hr />
        </div>

        <!-- If no users found for the team -->
        <p v-if="getUsersByTeam(team.id).length === 0">No users found for this team.</p>
      </v-expansion-panel-text>

    </v-expansion-panel>
  </v-expansion-panels>
</template>

<script lang="ts" setup>
import { ref } from 'vue';
import { getUserById } from '@/api/UserAPI.js' 

// Define the props to get the userId
const props = defineProps({
  userId: {
    type: [String, Number],
    required: true
  }
});

// Create a reactive `user` object to store the data
const user = ref({
  id: null,
  firstname: '',
  lastname: '',
  address: null,
  phone: null,
  birthdate: null,
  gender: null,
  salary: null,
  position: null,
  start_date: null,
  end_date: null,
  username: '',
  email: '',
  role_id: null,
  team_id: null,
  inserted_at: null,
  updated_at: null
});

// Mock function to simulate fetching user by ID
const getUserById = async (id: number | string) => {
  // Simulating a fetch request for user data
  return new Promise(resolve => {
    setTimeout(() => {
      resolve({
        id: 1,
        firstname: "Alice",
        lastname: "Johnson",
        address: null,
        phone: null,
        birthdate: null,
        gender: null,
        salary: null,
        position: null,
        start_date: null,
        end_date: null,
        username: "alice.johnson",
        email: "alice@example.com",
        role_id: [1,3],
        team_id: 1,
        inserted_at: "2024-10-16T12:58:01Z",
        updated_at: "2024-10-16T12:58:01Z"
      });
    }, 1000);
  });
};

// Fetch the user data once the component is mounted
onMounted(async () => {
    user.value = await getUserById(props.userId); // Store the fetched data in `user.value`
    // Uncomment this line when you're ready to fetch the user data
    // user.value = await getUserById(props.userId);
});

const mokedUser = ref({
    "id": 1,
    "firstname": "Alice",
    "lastname": "Johnson",
    "address": null,
    "phone": null,
    "birthdate": null,
    "gender": null,
    "salary": null,
    "position": null,
    "start_date": null,
    "end_date": null,
    "username": "alice.johnson",
    "email": "alice@example.com",
    "role_id": 1,
    "team_id": [1,3],
    "inserted_at": "2024-10-16T12:58:01Z",
    "updated_at": "2024-10-16T12:58:01Z"
});

const mokedAllTeam = ref({
    "data": [
        {
            "id": 1,
            "name": "comptability"
        },
        {
            "id": 2,
            "name": "security"
        },
        {
            "id": 3,
            "name": "it"
        }
    ]
})

const mockedTeam1 = ref([
[
    {
        "id": 1,
        "firstname": "Alice",
        "lastname": "Johnson",
        "address": null,
        "phone": null,
        "birthdate": null,
        "gender": null,
        "salary": null,
        "position": null,
        "start_date": null,
        "end_date": null,
        "username": "alice.johnson",
        "email": "alice@example.com",
        "role_id": 1,
        "team_id": 1,
        "inserted_at": "2024-10-16T12:58:01Z",
        "updated_at": "2024-10-16T12:58:01Z"
    },
    {
        "id": 2,
        "firstname": "Bob",
        "lastname": "Smith",
        "address": null,
        "phone": null,
        "birthdate": null,
        "gender": null,
        "salary": null,
        "position": null,
        "start_date": null,
        "end_date": null,
        "username": "bob.smith",
        "email": "bob@example.com",
        "role_id": 1,
        "team_id": 1,
        "inserted_at": "2024-10-16T12:58:01Z",
        "updated_at": "2024-10-16T12:58:01Z"
    },
    {
        "id": 3,
        "firstname": "Charlie",
        "lastname": "Brown",
        "address": null,
        "phone": null,
        "birthdate": null,
        "gender": null,
        "salary": null,
        "position": null,
        "start_date": null,
        "end_date": null,
        "username": "charlie.brown",
        "email": "charlie@example.com",
        "role_id": 1,
        "team_id": 1,
        "inserted_at": "2024-10-16T12:58:01Z",
        "updated_at": "2024-10-16T12:58:01Z"
    },
    {
        "id": 4,
        "firstname": "Diana",
        "lastname": "Prince",
        "address": null,
        "phone": null,
        "birthdate": null,
        "gender": null,
        "salary": null,
        "position": null,
        "start_date": null,
        "end_date": null,
        "username": "diana.prince",
        "email": "diana@example.com",
        "role_id": 1,
        "team_id": 1,
        "inserted_at": "2024-10-16T12:58:01Z",
        "updated_at": "2024-10-16T12:58:01Z"
    },
    {
        "id": 5,
        "firstname": "Eve",
        "lastname": "Adams",
        "address": null,
        "phone": null,
        "birthdate": null,
        "gender": null,
        "salary": null,
        "position": null,
        "start_date": null,
        "end_date": null,
        "username": "eve.adams",
        "email": "eve@example.com",
        "role_id": 2,
        "team_id": 1,
        "inserted_at": "2024-10-16T12:58:01Z",
        "updated_at": "2024-10-16T12:58:01Z"
    }
]
])

const mokedTeam3 = ref( [
    [
        {
        "id": 1,
        "firstname": "Alice",
        "lastname": "Johnson",
        "address": null,
        "phone": null,
        "birthdate": null,
        "gender": null,
        "salary": null,
        "position": null,
        "start_date": null,
        "end_date": null,
        "username": "alice.johnson",
        "email": "alice@example.com",
        "role_id": 1,
        "team_id": 1,
        "inserted_at": "2024-10-16T12:58:01Z",
        "updated_at": "2024-10-16T12:58:01Z"
    },
    {
        "id": 11,
        "firstname": "Liam",
        "lastname": "Garcia",
        "address": null,
        "phone": null,
        "birthdate": null,
        "gender": null,
        "salary": null,
        "position": null,
        "start_date": null,
        "end_date": null,
        "username": "liam.garcia",
        "email": "liam@example.com",
        "role_id": 3,
        "team_id": 3,
        "inserted_at": "2024-10-16T12:58:01Z",
        "updated_at": "2024-10-16T12:58:01Z"
    }
]
])
</script>

<style scoped>
</style>
