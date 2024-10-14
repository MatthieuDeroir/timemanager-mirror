import {ref} from 'vue'

// TODO - Example of a simple authentication composable, will be used in the future when we implement authentication, This method will be used to store the user information in the local storage:
export function useAuth() {
    const user = ref(null)
    const isAuthenticated = ref(false)

    const login = (userInfo) => {
        user.value = userInfo
        isAuthenticated.value = true
    }

    const logout = () => {
        user.value = null
        isAuthenticated.value = false
    }

        return {
        user,
        isAuthenticated,
        login,
        logout
    }
}
