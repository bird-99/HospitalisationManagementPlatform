<template>
  <div class="login-container">
    <div class="login-box">
      <h2>Hospital Management System</h2>
      <form @submit.prevent="handleLogin">
        <div class="input-group">
          <label for="username">Username</label>
          <input type="text" v-model="username" id="username" required />
        </div>
        <div class="input-group">
          <label for="password">Password</label>
          <input type="password" v-model="password" id="password" required />
        </div>
        <p v-if="error" class="error-message">{{ error }}</p>
        <button type="submit" class="login-button">Login</button>
        <p class="hint">
          Hint: Use <strong>admin</strong> / <strong>password</strong>
        </p>
      </form>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      username: "",
      password: "",
    };
  },
  methods: {
    handleLogin() {
      // Basic login logic
      if (this.username === "admin" && this.password === "password") {
        localStorage.setItem("isAuthenticated", "true");
        this.$router.push("/dashboard");
      } else {
        alert("Invalid credentials");
      }
    },
  },
};
</script>

<style scoped>
/* Add styling for login page */
.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100vh;
  background-color: #f0f2f5;
}
.login-box {
  padding: 2rem;
  background: white;
  border-radius: 8px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  text-align: center;
}
.input-group {
  margin-bottom: 1rem;
  text-align: left;
}
.input-group label {
  display: block;
  margin-bottom: 0.5rem;
}
.input-group input {
  width: 100%;
  padding: 0.5rem;
  border: 1px solid #ccc;
  border-radius: 4px;
}
.login-button {
  width: 100%;
  padding: 0.75rem;
  border: none;
  background-color: #007bff;
  color: white;
  border-radius: 4px;
  cursor: pointer;
}
.error-message {
  color: red;
  margin-bottom: 1rem;
}
.hint {
  margin-top: 1rem;
  color: #666;
}
</style>
