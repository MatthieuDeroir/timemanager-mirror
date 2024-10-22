export function handleError(error) {
  // console.log("--=-=-=-");
  // console.log(error.response);
  // console.log(error.request);
  // console.log(error.message);
  // console.log(error.response.status);
  // console.log(error.response.body);
  // console.log(error.response.data);
  // console.log("--=-=-=-");
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
