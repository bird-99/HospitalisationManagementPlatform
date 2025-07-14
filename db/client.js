const { Pool } = require('pg');

const client = new Pool({
  user: process.env.DB_USER || "postgres",
  host: process.env.DB_HOST || "db",
  database: process.env.DB_NAME || "hospitalisation_management",
  password: process.env.DB_PASSWORD || "password",
  port: process.env.DB_PORT || 5432,
});

module.exports = client;
