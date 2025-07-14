const express = require('express');
const path = require('path');
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
app.listen(PORT, () =>{
  console.log('Server is running on port', PORT);
});