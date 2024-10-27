
# **Gotham Time Manager
**

A **Vue.js-based** application for real-time log monitoring and management within a larger application. 
This dashboard dynamically displays logs related to user actions, authority levels, team management, and more. 
The application is powered by a backend API using **Elixir**, leveraging **Vuex** for centralized state management,
and built-in features for seamless dynamic loading and error handling.

---

## **Table of Contents**

1. [Features](#features)
2. [Project Structure](#project-structure)
3. [Setup and Installation](#setup-and-installation)
4. [Usage](#usage)
5. [Technologies Used](#technologies-used)
6. [File Structure](#file-structure)
7. [Contributing](#contributing)
8. [License](#license)

---

## **Features**

- **Real-time Logs Display**: Displays detailed log entries including username, action, message, date, and team.
- **Loader Component**: Shows a loading indicator while fetching data from the API.
- **Error Handling**: Displays error messages if data fetching fails, providing better user experience and troubleshooting.
- **Dynamic Data Updates**: Automatically listens for updates from the Vuex store and displays the latest log information.
- **Centralized State Management**: Uses Vuex for consistent state management across components.

---

## **Project Structure**

This project follows a modular **Vue 3** structure, utilizing **Vue.js** for centralized state management. 
Key components and store modules are organized for ease of navigation and maintainability.

### **Key Components**

- **Logs.vue**: The main component responsible for rendering logs.
- **Loader.vue**: A reusable component for displaying a loading spinner during data fetching.

## **Setup and Installation**

### **Prerequisites**

- Ensure **Node.js** and **npm** are installed on your machine.
- Ensure **Elixir** with the **Phoenix** Framework is available on your machine.

### **Installation**

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/git@github.com:EpitechMscProPromo2026/T-POO-700-NAN_5.git
   cd T-POO-700-NAN_5
   ```

2. **Configure Backend API**:
   - to congifure the backend, please refere to the ReadMe in the Backend folder.

3. **Run the application**:
   - to run the frontend please refere to the ReadMe in the Frontend folder.

---

## **Usage**

After the app is running, navigate to the main page to view real-time logs. Logs are loaded dynamically from the backend API and update automatically as new logs are added.

---
## Technologies Used
- **Elixir**: Functional programming language used for building scalable and maintainable applications.
- **Phoenix**: Framework for Elixir, designed for building web applications with high performance.
- **PostgreSQL**: Database management system for storing application data.
- **JWT (JSON Web Tokens)**: Used for secure user authentication and session management.
- **HTML/CSS**: Used in server-rendered templates if necessary for email notifications or similar purposes.
- **Node.js**: For running JavaScript-related tasks or scripts if needed in development.

---
## **Contributors**

- [Alexandre Lefay](https://github.com/AlexandreLefay)
- [Benjamin Couet](https://github.com/Nuuust) 
- [Matthieu Deroir](https://github.com/MatthieuDeroir)
- [Nicolas Cesari](https://github.com/ncesari49)
- [Arthur Lefrançois](https://github.com/Mr-terra)


---
## **Contributing**

Contributions to this project are welcome! To contribute, please follow these steps:

1. **Fork** the repository.
2. Create a **new branch** with a descriptive name for your feature or bug fix.
3. Make your changes and **test thoroughly**.
4. Submit a **pull request** with a clear description of your work.

---

