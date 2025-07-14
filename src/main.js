import { createApp } from "vue";
import App from "./App.vue";
import router from "./router";

// Create the Vue application instance
// This instance will manage the application lifecycle and render the root component
createApp(App).use(router).mount("#app");
