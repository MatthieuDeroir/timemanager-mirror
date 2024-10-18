import axios from 'axios'
import { handleError } from './handleError.js'

export const HttpClient = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL,
  headers: {
    'Content-Type': 'application/json'
  }
})

HttpClient.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('TOKEN')
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
    return response
  },
  (error) => {
    return handleError(error)
  }
)