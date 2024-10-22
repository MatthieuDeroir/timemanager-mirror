export function handleError(error) {
  let errorMessage = 'An unexpected error occurred.'

  if (error.response) {
    const status = error.response.status

    if (status >= 500) {
      errorMessage = 'Server error. Please try again later.'
    } else if (status >= 400) {
      if (status === 404) {
        errorMessage = 'Resource not found (404).'
      } else if (status === 401) {
        errorMessage = 'Unauthorized (401). Please log in.'
      } else {
        errorMessage = `Client error (status: ${status}).`
      }
    }
  } else if (error.request) {
    errorMessage = 'No response from server. Check your connection.'
  } else {
    errorMessage = error.message
  }

  console.error('API Error:', errorMessage)

  return Promise.reject(new Error(errorMessage))
}
