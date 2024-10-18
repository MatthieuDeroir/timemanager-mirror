import axios from 'axios'
import {handleError} from './handleError.js'

// Configuration d'Axios
export const HttpClient = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL,
  headers: {
    'Content-Type': 'application/json'
  },
  withCredentials: true
})

function getCookie(name) {
  const value = `; ${document.cookie}`
  const parts = value.split(`; ${name}=`)
  if (parts.length === 2) return parts.pop().split(';').shift()
}

function setJwtCookie(token) {
  const expires = new Date()
  expires.setTime(expires.getTime() + 24 * 60 * 60 * 1000)
  document.cookie = `jwt=${token}; path=/; expires=${expires.toUTCString()}; secure; samesite=strict;`
}

HttpClient.interceptors.request.use(
  (config) => {
    let token = localStorage.getItem('TOKEN')

    if (!token) {
      token = getCookie('jwt')
    }
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    const csrfToken = localStorage.getItem('CSRF_TOKEN')
    if (csrfToken) {
      config.headers['x-csrf-token'] = csrfToken
    }

    return config
  },
  (error) => {
    return Promise.reject(error)
  }
)

HttpClient.interceptors.response.use(
  (response) => {
    const jwtToken = getCookie('jwt')
    if (jwtToken) {
      localStorage.setItem('TOKEN', jwtToken)
    }

    const csrfToken = response.data.csrf_token

    if (csrfToken) {
      localStorage.setItem('CSRF_TOKEN', csrfToken)
    }
    return response
  },
  (error) => {
    return handleError(error)
  }
)
