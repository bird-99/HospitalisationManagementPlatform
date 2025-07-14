const express = require('express');
const router = express.Router();
const client = require('../db/client'); // Import the PostgreSQL client

//Route to get the team code list
router.get('/teams', async function(req, res) {
  // Get team code list from the database
  try {
    const result = await client.query(`SELECT DISTINCT id, team_code FROM hospital_mgt.dim_team;`);
    res.json(result.rows);
  } catch (err) {
    console.error('Error fetching teams:', err);
    res.status(500).send({ error: "Failed to fetch teams" });
  };
});


// Route to get the ward list based on team and gender
router.get('/wards', async (req, res) => {
    const { team, gender, excludeWard } = req.query;

    try {
        let query = `
            SELECT DISTINCT w.id, w.ward_code
            FROM hospital_mgt.dim_ward w
            JOIN hospital_mgt.dim_team t ON w.team_id = t.id
            JOIN hospital_mgt.dim_bed b ON w.id = b.ward_id
            WHERE t.id = $1
             AND  w.ward_gender = $2
             AND b.available_status = TRUE
        `;

        const params = [team, gender];

        // Add exclusion condition if excludeWardId is provided
        if (excludeWard) {
            query += ` AND w.ward_code != $3`;
            params.push(excludeWard);
        }

        const { rows } = await client.query(query, params);
        res.json(rows);
    } catch (err) {
        console.error('Error fetching wards:', err);  
        res.status(500).send({ error: 'Internal server error' });
    }
});
    
// Route to get the bed list based on ward
router.get('/beds', async (req, res) => {
    const { ward } = req.query;     

    try {
        const query = `
            SELECT id, bed_code
            FROM hospital_mgt.dim_bed
            WHERE ward_id = $1 AND available_status = TRUE;
        `;
        const { rows } = await client.query(query, [ward]);
        res.json(rows);
    } catch (err) {
        console.error('Error fetching beds:', err); 
        res.status(500).send({ error: 'Internal server error' });
    }
});

// Route to save patients record
router.post('/newpatients', async (req, res) => {
    const { name, dob, gender, team, ward, bed } = req.body;

    try {
        const insertQuery = `
        INSERT INTO hospital_mgt.dim_patient
            (name, dateofbirth, gender, ward_id, team_id, transferred, discharged, bed_id)
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
            RETURNING id;
        `;

        const values = [name, dob, gender, ward, team, false, false, bed];
        const result = await client.query(insertQuery, values);

        // mark the bed as unavailable
        await client.query(
            `UPDATE hospital_mgt.dim_bed SET available_status = FALSE WHERE id = $1;`,
            [bed]
        );

        res.status(201).json({ message: 'Patient added successfully', patientId: result.rows[0].id });
    } catch (err) {
        console.error('Error saving patient:', err);
        res.status(500).send({ error: 'Failed to save patient' });
    }
});


// Route to grab all current patients
router.get('/allcurrent', async (req, res) => {
    try {
        const showQuery = `
        SELECT 
            p.id,
            p.name,
            p.dateofbirth AS dob,
            p.gender,
            t.team_code AS team,
            w.ward_code AS ward,
            b.bed_code AS bed
        FROM hospital_mgt.dim_patient p
        JOIN hospital_mgt.dim_team t ON p.team_id = t.id
        JOIN hospital_mgt.dim_ward w ON p.ward_id = w.id
        JOIN hospital_mgt.dim_bed b ON p.bed_id = b.id
        WHERE p.discharged = FALSE;
        `;
        const result = await client.query(showQuery);
        res.json(result.rows);
    } catch (error) {
        console.error('Error fetching patients:', error);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});

// 


module.exports = router;