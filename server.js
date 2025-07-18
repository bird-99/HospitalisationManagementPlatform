const express = require('express');
const path = require('path');
const { pool } = require('./db/client');
const app = express();

// Middleware to handle JSON requests
app.use(express.json());   
app.use(express.static(path.join(__dirname, 'dist')));



// Mount routers
app.use('/api/patients', require('./routes/patientRoutes'));
app.use('/api/doctors', require('./routes/doctorRoutes'));
app.use('/api/wards', require('./routes/wardRoutes'));
app.use('/api/dashboard', require('./routes/dashboardRoutes'));


// Handle unknown API routes
app.use('/api', (req, res) => {
  res.status(404).json({ error: 'API route not found' });
});


// Fallback to index.html for SPA routing
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'dist', 'index.html'));
});


// Start the server
const PORT = process.env.PORT || 3000;

// Only start the server if this file is executed directly
if (require.main === module) {
  // Test database connection before starting server
  async function startServer() {
    try {
      // Test database connection
      const client = await pool.connect();
      await client.query('SELECT NOW()');
      client.release();
      console.log('Database connection verified');
      
      // Start the server only after successful database connection
      app.listen(PORT, () => {
        console.log('Server is running on port', PORT);
      });
    } catch (error) {
      console.error('Failed to connect to database:', error);
      process.exit(1);
    }
  }
  
  startServer();
}

// Export the app for testing or other uses
module.exports = app;