import axios from 'axios'
import {handleError} from './handleError.js'

// Crée une instance d'Axios
export const HttpClient = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL,
  headers: {
    'Content-Type': 'application/json'
  }
})

HttpClient.interceptors.response.use(
  (response) => {
    return response
  },
  (error) => {
    return handleError(error)
  }
)
