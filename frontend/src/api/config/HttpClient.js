import axios from 'axios'

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL

/** The configured Axios instance. */
export const HttpClient = axios.create({
  baseURL: `${API_BASE_URL}`
})