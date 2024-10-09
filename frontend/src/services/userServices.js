// userService.js

const API_BASE_URL = process.env.VUE_APP_API_BASE_URL;

/**
 * Fetch all users, or filter by email and/or username
 * @param {string} [email] - Optional email to filter users
 * @param {string} [username] - Optional username to filter users
 * @returns {Promise<UserDTO[]>}
 */
export async function getAllUsers(email = null, username = null) {
  const queryParams = new URLSearchParams();
  if (email) queryParams.append('email', email);
  if (username) queryParams.append('username', username);

  const response = await fetch(`${API_BASE_URL}users?${queryParams.toString()}`);
  return response.json();
}

/**
 * Fetch a user by ID
 * @param {number} userId
 * @returns {Promise<UserDTO>}
 */
export async function getUserById(userId) {
  const response = await fetch(`${API_BASE_URL}users/${userId}`);
  return response.json();
}

/**
 * Create a new user
 * @param {string} username
 * @param {string} email
 * @returns {Promise<UserDTO>}
 */
export async function createUser(username, email) {
  const response = await fetch(`${API_BASE_URL}users`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      user: {
        username,
        email
      }
    })
  });
  return response.json();
}

/**
 * Update a user by ID
 * @param {number} userId
 * @param {Object} userParams - User fields to update
 * @returns {Promise<UserDTO>}
 */
export async function updateUser(userId, userParams) {
  const response = await fetch(`${API_BASE_URL}users/${userId}`, {
    method: 'PUT',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      user: userParams
    })
  });
  return response.json();
}

/**
 * Delete a user by ID
 * @param {number} userId
 * @returns {Promise<void>}
 */
export async function deleteUser(userId) {
  await fetch(`${API_BASE_URL}users/${userId}`, {
    method: 'DELETE'
  });
}
