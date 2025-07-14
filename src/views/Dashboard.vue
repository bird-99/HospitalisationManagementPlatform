<template>
  <main class="dashboard-main">
    <section class="stats">
      <div class="stat-card">
        <h3>Patients</h3>
        <div class="stat-number">120</div>
      </div>
      <div class="stat-card">
        <h3>Wards</h3>
        <div class="stat-number">8</div>
      </div>
      <div class="stat-card">
        <h3>Doctors</h3>
        <div class="stat-number">25</div>
      </div>
    </section>
    <section class="card">
      <h2>All Patients</h2>
      <div class="grid">
        <PatientCard
          v-for="patient in patients"
          :key="patient.id"
          :patient="patient"
        />
      </div>
    </section>
  </main>
</template>

<style scoped>
#dashboard {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}
.dashboard-header {
  display: flex;
  flex-direction: column;
  background-color: #333;
  color: white;
  padding: 1rem;
}
.dashboard-nav {
  display: flex;
  gap: 1rem;
  align-items: center;
  margin-top: 0.5rem;
}
.dashboard-nav a {
  color: white;
  text-decoration: none;
  font-weight: bold;
}
.logout-btn {
  margin-left: auto;
  background: #e74c3c;
  color: white;
  border: none;
  padding: 0.5rem 1rem;
  cursor: pointer;
  border-radius: 4px;
}
.dashboard-main {
  flex: 1;
  padding: 2rem;
  background: #f5f5f5;
}
.stats {
  display: flex;
  gap: 2rem;
  margin-bottom: 2rem;
  justify-content: center;
}
.stat-card {
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.07);
  padding: 1.5rem 2rem;
  text-align: center;
  min-width: 150px;
}
.stat-card h3 {
  margin: 0 0 0.5rem 0;
  font-size: 1.1rem;
  color: #555;
}
.stat-number {
  font-size: 2.5rem;
  font-weight: bold;
  color: #3498db;
}
.card {
  background: white;
  border-radius: 8px;
  padding: 2rem;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}
.grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: 1rem;
  margin-top: 1rem;
}
</style>
