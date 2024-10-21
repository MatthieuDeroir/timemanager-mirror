import axios from 'axios'
import { handleError } from './handleError.js'

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

HttpClient.interceptors.request.use(
  (config) => {
    let token = localStorage.getItem('TOKEN')

    if (!token) {
      token = getCookie('jwt')
    }

    if (token) {
      config.headers.Authorization = `Bearer ${token}`
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
    return response
  },
  (error) => {
    return handleError(error)
  }
)