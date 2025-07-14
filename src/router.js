import { createRouter, createWebHashHistory } from "vue-router";
import Login from "./views/Login.vue";
import Dashboard from "./views/Dashboard.vue";
import Patients from "./views/Patients.vue";
import Teams from "./views/Teams.vue";
import Ward from "./views/Ward.vue";

// Define the routes for the application
// Each route maps a path to a component
const routes = [
  { path: "/", name: "Login", component: Login },
  {
    path: "/dashboard",
    name: "Dashboard",
    component: Dashboard,
  },
  {
    path: "/patients",
    name: "Patients",
    component: Patients,
  },
  {
    path: "/teams",
    name: "Teams",
    component: Teams,
  },
  {
    path: "/ward",
    name: "Ward",
    component: Ward,
  },
  // Add more routes here as needed
];

// Create the router instance
// This instance will manage the navigation between different views
const router = createRouter({
  history: createWebHashHistory(),
  routes,
});

export default router;
