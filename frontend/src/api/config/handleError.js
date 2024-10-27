import { useToast } from 'vue-toast-notification'
import 'vue-toast-notification/dist/theme-sugar.css'

export function handleError(error) {
  let errorMessage = 'An unexpected error occurred.'
  const $toast = useToast()
  const options = {
    position: 'top-left',
    duration: 10000,
    dismissible: true
  }

  if (error.response) {
    const status = error.response.status

    if (status >= 500) {
      errorMessage = 'Server error. Please try again later.'
      $toast.error(errorMessage, options)
    } else if (status >= 400) {
      if (status === 404) {
        errorMessage = 'Resource not found (404).'
        $toast.error(errorMessage, options)
      } else if (status === 401) {
        errorMessage = 'Unauthorized (401). Please log in.'
        $toast.error(errorMessage, options)
      } else {
        errorMessage = `Client error (status: ${status}).`
        $toast.error(errorMessage, options)
      }
    }
  } else if (error.request) {
    errorMessage = 'No response from server. Check your connection.'
    $toast.error(errorMessage, options)
  } else {
    errorMessage = error.message
  }

  console.error('API Error:', errorMessage)

  return Promise.reject(new Error(errorMessage))
}
