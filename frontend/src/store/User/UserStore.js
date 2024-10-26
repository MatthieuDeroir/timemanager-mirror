import { defineStore } from 'pinia'
import { ref } from 'vue'
import UserAPI from '@/api/UserAPI'
import { handleApiRequest } from '@config/lokiJS/syncHelper'
import { useToast } from 'vue-toast-notification'
import 'vue-toast-notification/dist/theme-sugar.css'

/**
 * Defines a store for managing user data.
 */
export const useUserStore = defineStore('userStore', () => {
  const users = ref([])
  const isLoading = ref(false)
  const error = ref(null)
  const $toast = useToast()
  const options = {
    position: 'top-left',
    duration: 1000,
    dismissible: true
  }

  /**
   * Loads all users from the API.
   * Sets the `isLoading` state to true while loading and false after loading.
   */
  const loadAllUsers = async () => {
    isLoading.value = true
    users.value = await UserAPI.loadAllUsers()
    isLoading.value = false
  }

  /**
   * Creates a new user.
   * Sets the `isLoading` state to true while creating and false after creating.
   * @param {Object} data - The data of the new user to create.
   */
  const createUser = async (data) => {
    isLoading.value = true
    const newUser = await handleApiRequest('create', data, 'createUser').then()
    $toast.success('Employee successfully created.', options)
    users.value.push(newUser)
    isLoading.value = false
  }

  /**
   * Updates an existing user.
   * Sets the `isLoading` state to true while updating and false after updating.
   * @param {string} id - The ID of the user to update.
   * @param {Object} data - The updated data of the user.
   */
  const updateUser = async (id, data) => {
    isLoading.value = true
    const updatedUser = await handleApiRequest('update', data, 'updateUser', id)
    $toast.success('Employee successfully edited.', options)
    users.value = users.value.map((user) => (user.id === id ? updatedUser : user))
    isLoading.value = false
  }

  /**
   * Deletes an existing user.
   * Sets the `isLoading` state to true while deleting and false after deleting.
   * @param {string} id - The ID of the user to delete.
   */
  const deleteUser = async (id) => {
    isLoading.value = true
    await handleApiRequest('delete', null, 'deleteUser', id)
    $toast.success('Employee successfully deleted.', options)
    users.value = users.value.filter((user) => user.id !== id)
    isLoading.value = false
  }

  return {
    users,
    isLoading,
    error,
    loadAllUsers,
    createUser,
    updateUser,
    deleteUser
  }
})
