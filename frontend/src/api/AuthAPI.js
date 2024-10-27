import { HttpClient } from '@/api/config/HttpClient.js'

/**
 * Login API
 * Method use to login the user
 * @param {Object} data - The user data (email, password).
 */
export const loginUser = (data) =>
  HttpClient.post('/auth/login', {
    email: data.email,
    password: data.password
  }).then((res) => res.data)

/**
 * Logout API
 * Method use to logout the user from the context application
 * @returns {Promise}
 */
export const logoutUser = () => {
  HttpClient.post('/auth/logout')
}
