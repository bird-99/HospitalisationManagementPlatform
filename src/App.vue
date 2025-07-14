<template>
  <div id="app">
    <header>
      <nav>
        <router-link to="/dashboard">Dashboard</router-link>
        <router-link to="/patients">Patients</router-link>
        <router-link to="/ward">Wards View</router-link>
        <router-link to="/teams">Teams View</router-link>
      </nav>
      <button @click="logout" class="logout-btn">Logout</button>
    </header>
    <main>
      <router-view />
    </main>
  </div>
</template>
<script>
export default {
  name: "App",
};
</script>

<style>
/* Add global styles in a separate file like assets/css/main.css if preferred */
body {
  font-family: sans-serif;
  margin: 0;
}
#app {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}
header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background-color: #333;
  color: white;
  padding: 1rem;
}
header nav a {
  color: white;
  margin-right: 1.5rem;
  text-decoration: none;
}
header nav a.router-link-exact-active {
  font-weight: bold;
  text-decoration: underline;
}
.logout-btn {
  background: #dc3545;
  color: white;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 4px;
  cursor: pointer;
}
main {
  padding: 2rem;
  flex-grow: 1;
}
.card {
  background: #fff;
  padding: 1.5rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  margin-bottom: 1rem;
}
.grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 1rem;
}
.input-field,
.select-field {
  padding: 0.5rem;
  margin-right: 0.5rem;
  border: 1px solid #ccc;
  border-radius: 4px;
}
button {
  background-color: #007bff;
  color: white;
  border: none;
  padding: 0.6rem 1rem;
  border-radius: 5px;
  cursor: pointer;
  font-weight: bold;
  cursor: pointer;
  transition: background-color 0.3s ease;
}
.top-action-buttons {
  display: flex;
  gap: 8px;
}
button:hover {
  opacity: 0.9;
  background-color: #155a9e;
}
.patient-list {
  margin-top: 20px;
}

.patient-card {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  border: 2px solid #ccc;
  padding: 16px;
  margin-bottom: 12px;
  border-radius: 8px;
  transition: background-color 0.3s, border-color 0.3s;
}

.patient-card.selected {
  background-color: #def3ff;
  border-color: #2196f3;
}

.patient-card.selected {
  background-color: #def3ff;
  border-color: #2196f3;
}

.patient-info {
  flex-grow: 1;
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
  flex-grow: 1;
  align-items: center;
}

.patient-info p {
  margin: 4px 0;
  font-size: 15px;
}

.patient-checkbox-wrapper {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.patient-checkbox {
  transform: scale(1.4);
  cursor: pointer;
  margin-bottom: 5px;
}

.checkbox-label {
  font-weight: bold;
  font-size: 14px;
  color: #333;
}

.transfer-form {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
  margin-bottom: 10px;
}
</style>
