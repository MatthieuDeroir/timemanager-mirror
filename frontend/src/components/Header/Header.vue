<template>
  <header class="header">
    <img alt="Gotham Logo" class="navbar-logo" src="@/assets/global/batman.png" />
    <div
      v-if="
        (authStore?.user && authStore.user?.role_id === UserRole.ADMIN) ||
        authStore?.user?.role_id === UserRole.GENERAL_MANAGER
      "
    >
      <UserSearch @user-selected="handleUserSelected" />
    </div>
    <div>
      <v-menu open-on-click>
        <template v-slot:activator="{ props }">
          <div
            :style="{ background: 'var(--linear-' + getColor() + ')' }"
            class="user-preferences"
            v-bind="props"
          >
            {{ getInitial }}
          </div>
        </template>
        <v-list>
          <v-list-item>
            <v-list-item-title>
              <ColorPicker @colorSelected="passEmitingColor" />
            </v-list-item-title>
          </v-list-item>
          <v-list-item v-for="(item, index) in items" :key="index" @click="handleItemClick(item)">
            <v-list-item-title>{{ item.title }}</v-list-item-title>
          </v-list-item>
        </v-list>
      </v-menu>
    </div>
  </header>
</template>

<script lang="ts" setup>
import UserSearch from '../../components/user/UserSearch/UserSearch.vue'
import ColorPicker from './ColourPicker/ColourPicker.vue'
import { ref } from 'vue'
import { useAuthStore } from '@store/Auth/AuthStore'
import { useAuth } from '@composables/useAuth'
import { UserRole } from '@enum/User/UserRole'

const items = [{ title: 'Profil' }, { title: 'Log out' }]

const emit = defineEmits(['colorSelected'])
const authStore = useAuthStore()
const auth = useAuth()
const getInitial = auth.getUserInitial()
const selectedUserId = ref<number | null>(null)

const handleUserSelected = (userId: number) => {
  selectedUserId.value = userId
}

const passEmitingColor = (color) => {
  emit('colorSelected', color)
}

const handleItemClick = (item) => {
  if (item.title === 'Log out') {
    auth.logout()
  }
}

function getColor() {
  const selectedColorClass = ref('blue')
  const storedColor = localStorage.getItem('selectedColor')
  if (storedColor) {
    const color = JSON.parse(storedColor)
    selectedColorClass.value = color.name.toLowerCase()
  }
  return selectedColorClass.value
}
</script>

<style scoped src="./Header.css"></style>
