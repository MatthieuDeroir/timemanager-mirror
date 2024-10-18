<template>
  <v-expansion-panels>
    <v-expansion-panel v-for="team in getUserTeams()" :key="team.id">
      <v-expansion-panel-title>
        {{ team.name }}
      </v-expansion-panel-title>

      <v-expansion-panel-text>
        <div class="UserDiv">
          <span class="UserRolle">Position</span>
          <span class="UserFirstName">First Name</span>
          <span class="UserLastName">Last Name</span>
        </div>
        <div v-for="user in getUsersByTeam(team.id)" :key="user.id" class="UserDiv">
          <span class="UserRolle">{{ getRoleName(user.role_id) }}</span>
          <span class="UserFirstName">{{ user.firstname }}</span>
          <span class="UserLastName">{{ user.lastname }}</span>
          <a :href="`mailto:${user.email}`" class="mailto-link">
            <img :src="emailIcon" alt="Email Us" />
          </a>
          <hr />
        </div>

        <p v-if="getUsersByTeam(team.id).length === 0">No users found for this team.</p>
      </v-expansion-panel-text>
    </v-expansion-panel>
  </v-expansion-panels>
</template>

<script lang="ts" setup>
import { ref } from 'vue';
import emailIcon from '@assets/icons/icons8-mail-48.png'

const props = defineProps({
  userId: {
    type: [String, Number],
    required: true,
  },
});

const mokedUser = ref({
  id: 1,
  firstname: 'Alice',
  lastname: 'Johnson',
  address: null,
  phone: null,
  birthdate: null,
  gender: null,
  salary: null,
  position: null,
  start_date: null,
  end_date: null,
  username: 'alice.johnson',
  email: 'alice@example.com',
  role_id: 1,
  team_id: [1, 3],
  inserted_at: '2024-10-16T12:58:01Z',
  updated_at: '2024-10-16T12:58:01Z',
});

const mokedAllTeam = ref({
  data: [
    { id: 1, name: 'comptability' },
    { id: 2, name: 'security' },
    { id: 3, name: 'it' },
  ],
});

const mockedUsers = ref([
  {
    id: 1,
    firstname: 'Alice',
    lastname: 'Johnson',
    address: null,
    phone: null,
    birthdate: null,
    gender: null,
    salary: null,
    position: null,
    start_date: null,
    end_date: null,
    username: 'alice.johnson',
    email: 'alice@example.com',
    role_id: 1,
    team_id: [1, 3],
    inserted_at: '2024-10-16T12:58:01Z',
    updated_at: '2024-10-16T12:58:01Z',
  },
  {
    id: 2,
    firstname: 'Bob',
    lastname: 'Smith',
    address: null,
    phone: null,
    birthdate: null,
    gender: null,
    salary: null,
    position: null,
    start_date: null,
    end_date: null,
    username: 'bob.smith',
    email: 'bob@example.com',
    role_id: 1,
    team_id: [1],
    inserted_at: '2024-10-16T12:58:01Z',
    updated_at: '2024-10-16T12:58:01Z',
  },
  {
    id: 3,
    firstname: 'Charlie',
    lastname: 'Brown',
    address: null,
    phone: null,
    birthdate: null,
    gender: null,
    salary: null,
    position: null,
    start_date: null,
    end_date: null,
    username: 'charlie.brown',
    email: 'charlie@example.com',
    role_id: 1,
    team_id: [1],
    inserted_at: '2024-10-16T12:58:01Z',
    updated_at: '2024-10-16T12:58:01Z',
  },
  {
    id: 4,
    firstname: 'Diana',
    lastname: 'Prince',
    address: null,
    phone: null,
    birthdate: null,
    gender: null,
    salary: null,
    position: null,
    start_date: null,
    end_date: null,
    username: 'diana.prince',
    email: 'diana@example.com',
    role_id: 1,
    team_id: [1],
    inserted_at: '2024-10-16T12:58:01Z',
    updated_at: '2024-10-16T12:58:01Z',
  },
  {
    id: 5,
    firstname: 'Eve',
    lastname: 'Adams',
    address: null,
    phone: null,
    birthdate: null,
    gender: null,
    salary: null,
    position: null,
    start_date: null,
    end_date: null,
    username: 'eve.adams',
    email: 'eve@example.com',
    role_id: 2,
    team_id: [1],
    inserted_at: '2024-10-16T12:58:01Z',
    updated_at: '2024-10-16T12:58:01Z',
  },
  {
    id: 11,
    firstname: 'Liam',
    lastname: 'Garcia',
    address: null,
    phone: null,
    birthdate: null,
    gender: null,
    salary: null,
    position: null,
    start_date: null,
    end_date: null,
    username: 'liam.garcia',
    email: 'liam@example.com',
    role_id: 3,
    team_id: [3],
    inserted_at: '2024-10-16T12:58:01Z',
    updated_at: '2024-10-16T12:58:01Z',
  },
]);

const mockedRoles = ref([
  { id: 1, name: 'employee' },
  { id: 2, name: 'manager' },
  { id: 3, name: 'admin' }
]);

const getUserTeams = () => {
  return mokedAllTeam.value.data.filter((team) => mokedUser.value.team_id.includes(team.id));
};

const getRoleName = (roleId) => {
  const role = mockedRoles.value.find(role => role.id === roleId);
  return role ? role.name : 'Unknown Role'; 
};

const getUsersByTeam = (teamId) => {
  return mockedUsers.value
    .filter((user) => {
      return Array.isArray(user.team_id) ? user.team_id.includes(teamId) : user.team_id === teamId;
    })
    .sort((a, b) => {
      const rolePriority = { admin: 1, manager: 2, employee: 3 }; 
      const roleA = getRoleName(a.role_id);
      const roleB = getRoleName(b.role_id);
      return (rolePriority[roleA] || 4) - (rolePriority[roleB] || 4); 
    });
};
</script>

<style scoped>
.UserDiv {
  display: flex;
  align-items: center;
}

.UserRolle {
  width: 100px;
  margin-right: 10px;
}

.UserFirstName {
  width: 100px;
  margin-right: 10px;
}

.UserLastName {
  width: 100px;
  margin-right: 10px;
}


.mailto-link {
  display: flex;
  align-items: center; 
}



</style>
