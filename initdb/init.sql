-- Create a schema named 'hospital_management'
CREATE SCHEMA IF NOT EXISTS "hospital_mgt";
SET search_path TO "hospital_mgt";


-- Create tables in the 'hospital_management' schema

CREATE TABLE "dim_team"(
    "id" SERIAL NOT NULL,
    "team_code" VARCHAR(255) NOT NULL,
    "department_id" INTEGER NOT NULL
);
ALTER TABLE
    "dim_team" ADD PRIMARY KEY("id");
CREATE TABLE "dim_patient"(
    "id" SERIAL NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "gender" VARCHAR(255) NOT NULL,
    "dateofbirth" DATE NOT NULL, -- calculate age in queries
    "ward_id" INTEGER NOT NULL,
    "team_id" INTEGER NOT NULL,
    "transferred" BOOLEAN NOT NULL,
    "discharged" BOOLEAN NOT NULL,
    "bed_id" INTEGER NOT NULL
);
ALTER TABLE
    "dim_patient" ADD PRIMARY KEY("id");
CREATE TABLE "fct_treatment"(
    "id" SERIAL NOT NULL,
    "patient_id" INTEGER NOT NULL,
    "doctor_id" INTEGER NOT NULL,
    "timestamp" TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL
);
ALTER TABLE
    "fct_treatment" ADD PRIMARY KEY("id");
CREATE TABLE "dim_ward"(
    "id" SERIAL NOT NULL,
    "ward_code" VARCHAR(255) NOT NULL,
    "ward_gender" VARCHAR(255) NOT NULL,
    "team_id" INTEGER NOT NULL
);
ALTER TABLE
    "dim_ward" ADD PRIMARY KEY("id");
CREATE TABLE "dim_department"(
    "id" SERIAL NOT NULL,
    "department_code" VARCHAR(255) NOT NULL,
    "department_name" VARCHAR(255) NOT NULL
);
ALTER TABLE
    "dim_department" ADD PRIMARY KEY("id");
CREATE TABLE "dim_doctor"(
    "id" SERIAL NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "grade" VARCHAR(255) NOT NULL,
    "team_id" INTEGER NOT NULL
);
ALTER TABLE
    "dim_doctor" ADD PRIMARY KEY("id");
CREATE TABLE "dim_bed"(
    "id" SERIAL NOT NULL,
    "ward_id" INTEGER NOT NULL,
    "bed_code" VARCHAR(255) NOT NULL,
    "available_status" BOOLEAN NOT NULL DEFAULT TRUE
);
ALTER TABLE
    "dim_bed" ADD PRIMARY KEY("id");
ALTER TABLE
    "dim_patient" ADD CONSTRAINT "dim_patient_team_id_foreign" FOREIGN KEY("team_id") REFERENCES "dim_team"("id");
ALTER TABLE
    "fct_treatment" ADD CONSTRAINT "fct_treatment_patient_id_foreign" FOREIGN KEY("patient_id") REFERENCES "dim_patient"("id");
ALTER TABLE
    "dim_team" ADD CONSTRAINT "dim_team_department_id_foreign" FOREIGN KEY("department_id") REFERENCES "dim_department"("id");
ALTER TABLE
    "dim_doctor" ADD CONSTRAINT "dim_doctor_team_id_foreign" FOREIGN KEY("team_id") REFERENCES "dim_team"("id");
ALTER TABLE
    "dim_ward" ADD CONSTRAINT "dim_ward_team_id_foreign" FOREIGN KEY("team_id") REFERENCES "dim_team"("id");
ALTER TABLE
    "dim_patient" ADD CONSTRAINT "dim_patient_bed_id_foreign" FOREIGN KEY("bed_id") REFERENCES "dim_bed"("id");
ALTER TABLE
    "fct_treatment" ADD CONSTRAINT "fct_treatment_doctor_id_foreign" FOREIGN KEY("doctor_id") REFERENCES "dim_doctor"("id");
ALTER TABLE
    "dim_bed" ADD CONSTRAINT "dim_bed_ward_id_foreign" FOREIGN KEY("ward_id") REFERENCES "dim_ward"("id");

-- Add indexes for performance optimization
-- Indexes for foreign keys in dim_patient
CREATE INDEX idx_patient_team_id ON dim_patient(team_id);
CREATE INDEX idx_patient_ward_id ON dim_patient(ward_id);
CREATE INDEX idx_patient_bed_id ON dim_patient(bed_id);

-- Indexes for foreign keys in fct_treatment
CREATE INDEX idx_treatment_patient_id ON fct_treatment(patient_id);
CREATE INDEX idx_treatment_doctor_id ON fct_treatment(doctor_id);

-- Indexes for foreign keys in dim_team
CREATE INDEX idx_team_department_id ON dim_team(department_id);

-- Index for foreign key in dim_doctor
CREATE INDEX idx_doctor_team_id ON dim_doctor(team_id);

-- Index for foreign key in dim_ward
CREATE INDEX idx_ward_team_id ON dim_ward(team_id);

-- Index for foreign key in dim_bed
CREATE INDEX idx_bed_ward_id ON dim_bed(ward_id);



-- Insert initial data into the tables

-- 4 departments
INSERT INTO dim_department (id, department_code, department_name) VALUES (1, 'CARD', 'Cardiology');
INSERT INTO dim_department (id, department_code, department_name) VALUES (2, 'ONCO', 'Oncology');
INSERT INTO dim_department (id, department_code, department_name) VALUES (3, 'NEUR', 'Neurology');
INSERT INTO dim_department (id, department_code, department_name) VALUES (4, 'ORTH', 'Orthopedics');



-- team 1, with 4 doctors
INSERT INTO dim_team (id, team_code, department_id) VALUES (1, 'CARD01', 1);
INSERT INTO dim_doctor (id, name, grade, team_id) VALUES (1, 'Dr. Blake', 'Consultant', 1);
INSERT INTO dim_doctor (id, name, grade, team_id) VALUES (2, 'Dr. Waston ', 'G1', 1);
INSERT INTO dim_doctor (id, name, grade, team_id) VALUES (3, 'Dr. Brooks', 'G2', 1);
INSERT INTO dim_doctor (id, name, grade, team_id) VALUES (4, 'Dr. Carter', 'G3', 1);

-- team 1, with 4 wards and 20 beds
INSERT INTO dim_ward (id, ward_code, ward_gender, team_id) VALUES (1, 'CARD01-W1', 'Male', 1);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (1, 1, 'CARD01-W1-B1', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (2, 1, 'CARD01-W1-B2', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (3, 1, 'CARD01-W1-B3', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (4, 1, 'CARD01-W1-B4', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (5, 1, 'CARD01-W1-B5', TRUE);

INSERT INTO dim_ward (id, ward_code, ward_gender, team_id) VALUES (2, 'CARD01-W2', 'Male', 1);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (6, 2, 'CARD01-W2-B1', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (7, 2, 'CARD01-W2-B2', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (8, 2, 'CARD01-W2-B3', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (9, 2, 'CARD01-W2-B4', TRUE);

INSERT INTO dim_ward (id, ward_code, ward_gender, team_id) VALUES (3, 'CARD01-W3', 'Female', 1);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (10, 2, 'CARD01-W2-B5', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (11, 3, 'CARD01-W3-B1', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (12, 3, 'CARD01-W3-B2', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (13, 3, 'CARD01-W3-B3', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (14, 3, 'CARD01-W3-B4', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (15, 3, 'CARD01-W3-B5', TRUE);

INSERT INTO dim_ward (id, ward_code, ward_gender, team_id) VALUES (4, 'CARD01-W4', 'Female', 1);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (16, 4, 'CARD01-W4-B1', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (17, 4, 'CARD01-W4-B2', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (18, 4, 'CARD01-W4-B3', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (19, 4, 'CARD01-W4-B4', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (20, 4, 'CARD01-W4-B5', TRUE);


-- team 2, with 4 doctors
INSERT INTO dim_team (id, team_code, department_id) VALUES (2, 'ONCO01', 2);
INSERT INTO dim_doctor (id, name, grade, team_id) VALUES (5, 'Dr. Kate', 'Consultant', 2);
INSERT INTO dim_doctor (id, name, grade, team_id) VALUES (6, 'Dr. Forrest', 'G1', 2);
INSERT INTO dim_doctor (id, name, grade, team_id) VALUES (7, 'Dr. Ashford', 'G2', 2);
INSERT INTO dim_doctor (id, name, grade, team_id) VALUES (8, 'Dr. Johnson', 'G3', 2);

-- team 2, with 4 wards and 20 beds
INSERT INTO dim_ward (id, ward_code, ward_gender, team_id) VALUES (5, 'ONCO01-W1', 'Male', 2);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (21, 5, 'ONCO01-W1-B1', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (22, 5, 'ONCO01-W1-B2', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (23, 5, 'ONCO01-W1-B3', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (24, 5, 'ONCO01-W1-B4', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (25, 5, 'ONCO01-W1-B5', TRUE);


INSERT INTO dim_ward (id, ward_code, ward_gender, team_id) VALUES (6, 'ONCO01-W2', 'Male', 2);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (26, 6, 'ONCO01-W2-B1', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (27, 6, 'ONCO01-W2-B2', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (28, 6, 'ONCO01-W2-B3', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (29, 6, 'ONCO01-W2-B4', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (30, 6, 'ONCO01-W2-B5', TRUE);

INSERT INTO dim_ward (id, ward_code, ward_gender, team_id) VALUES (7, 'ONCO01-W3', 'Female', 2);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (31, 7, 'ONCO01-W3-B1', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (32, 7, 'ONCO01-W3-B2', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (33, 7, 'ONCO01-W3-B3', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (34, 7, 'ONCO01-W3-B4', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (35, 7, 'ONCO01-W3-B5', TRUE);

INSERT INTO dim_ward (id, ward_code, ward_gender, team_id) VALUES (8, 'ONCO01-W4', 'Female', 2);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (36, 8, 'ONCO01-W4-B1', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (37, 8, 'ONCO01-W4-B2', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (38, 8, 'ONCO01-W4-B3', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (39, 8, 'ONCO01-W4-B4', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (40, 8, 'ONCO01-W4-B5', TRUE);

-- team 3, with 4 doctors
INSERT INTO dim_team (id, team_code, department_id) VALUES (3, 'NEUR01', 3);
INSERT INTO dim_doctor (id, name, grade, team_id) VALUES (9, 'Dr. Potter', 'Consultant', 3);
INSERT INTO dim_doctor (id, name, grade, team_id) VALUES (10, 'Dr. Wu', 'G1', 3);
INSERT INTO dim_doctor (id, name, grade, team_id) VALUES (11, 'Dr. Lynn', 'G2', 3);
INSERT INTO dim_doctor (id, name, grade, team_id) VALUES (12, 'Dr. Smith', 'G3', 3);

-- team 3, with 4 wards and 20 beds
INSERT INTO dim_ward (id, ward_code, ward_gender, team_id) VALUES (9, 'NEUR01-W1', 'Male', 3);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (41, 9, 'NEUR01-W1-B1', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (42, 9, 'NEUR01-W1-B2', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (43, 9, 'NEUR01-W1-B3', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (44, 9, 'NEUR01-W1-B4', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (45, 9, 'NEUR01-W1-B5', TRUE);

INSERT INTO dim_ward (id, ward_code, ward_gender, team_id) VALUES (10, 'NEUR01-W2', 'Male', 3);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (46, 10, 'NEUR01-W2-B1', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (47, 10, 'NEUR01-W2-B2', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (48, 10, 'NEUR01-W2-B3', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (49, 10, 'NEUR01-W2-B4', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (50, 10, 'NEUR01-W2-B5', TRUE);

INSERT INTO dim_ward (id, ward_code, ward_gender, team_id) VALUES (11, 'NEUR01-W3', 'Female', 3);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (51, 11, 'NEUR01-W3-B1', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (52, 11, 'NEUR01-W3-B2', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (53, 11, 'NEUR01-W3-B3', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (54, 11, 'NEUR01-W3-B4', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (55, 11, 'NEUR01-W3-B5', TRUE);

INSERT INTO dim_ward (id, ward_code, ward_gender, team_id) VALUES (12, 'NEUR01-W4', 'Female', 3);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (56, 12, 'NEUR01-W4-B1', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (57, 12, 'NEUR01-W4-B2', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (58, 12, 'NEUR01-W4-B3', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (59, 12, 'NEUR01-W4-B4', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (60, 12, 'NEUR01-W4-B5', TRUE);

-- team 4, with 4 doctors
INSERT INTO dim_team (id, team_code, department_id) VALUES (4, 'ORTH01', 4);
INSERT INTO dim_doctor (id, name, grade, team_id) VALUES (13, 'Dr. Stevens', 'Consultant', 4);
INSERT INTO dim_doctor (id, name, grade, team_id) VALUES (14, 'Dr. Adams', 'G1', 4);
INSERT INTO dim_doctor (id, name, grade, team_id) VALUES (15, 'Dr. Palmer', 'G2', 4);
INSERT INTO dim_doctor (id, name, grade, team_id) VALUES (16, 'Dr. Hayers', 'G3', 4);

-- team 4, with 4 wards and 20 beds
INSERT INTO dim_ward (id, ward_code, ward_gender, team_id) VALUES (13, 'ORTH01-W1', 'Male', 4);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (61, 13, 'ORTH01-W1-B1', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (62, 13, 'ORTH01-W1-B2', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (63, 13, 'ORTH01-W1-B3', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (64, 13, 'ORTH01-W1-B4', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (65, 13, 'ORTH01-W1-B5', TRUE);

INSERT INTO dim_ward (id, ward_code, ward_gender, team_id) VALUES (14, 'ORTH01-W2', 'Male', 4);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (66, 14, 'ORTH01-W2-B1', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (67, 14, 'ORTH01-W2-B2', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (68, 14, 'ORTH01-W2-B3', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (69, 14, 'ORTH01-W2-B4', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (70, 14, 'ORTH01-W2-B5', TRUE);

INSERT INTO dim_ward (id, ward_code, ward_gender, team_id) VALUES (15, 'ORTH01-W3', 'Female', 4);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (71, 15, 'ORTH01-W3-B1', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (72, 15, 'ORTH01-W3-B2', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (73, 15, 'ORTH01-W3-B3', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (74, 15, 'ORTH01-W3-B4', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (75, 15, 'ORTH01-W3-B5', TRUE);

INSERT INTO dim_ward (id, ward_code, ward_gender, team_id) VALUES (16, 'ORTH01-W4', 'Female', 4);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (76, 16, 'ORTH01-W4-B1', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (77, 16, 'ORTH01-W4-B2', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (78, 16, 'ORTH01-W4-B3', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (79, 16, 'ORTH01-W4-B4', TRUE);
INSERT INTO dim_bed (id, ward_id, bed_code, available_status) VALUES (80, 16, 'ORTH01-W4-B5', TRUE);

