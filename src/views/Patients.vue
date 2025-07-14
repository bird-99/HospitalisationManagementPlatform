<template>
  <div>
    <h1>Patient Management</h1>
    <!-- Action buttons below title -->
    <!-- Transfer / Treatment / Discharge buttons -->
    <div class="top-action-buttons">
      <button class="action-btn" @click="showTransfer = !showTransfer">
        Transfer
      </button>
      <button class="action-btn">Treatment</button>
      <button class="action-btn">Discharge</button>
    </div>

    <!-- Conditional Transfer Options -->
    <div v-if="showTransfer" class="transfer-form">
      <select v-model="transfer.team" class="select-field">
        <option disabled value="">Select New Team</option>
        <option v-for="team in teams" :key="team.id" :value="team.id">
          {{ team.team_code }}
        </option>
      </select>

      <select v-model="transfer.ward" class="select-field">
        <option disabled value="">Select New Ward</option>
        <option v-for="ward in transferWards" :key="ward.id" :value="ward.id">
          {{ ward.ward_code }}
        </option>
      </select>

      <select v-model="transfer.bed" class="select-field">
        <option disabled value="">Select New Bed</option>
        <option v-for="bed in transferBeds" :key="bed.id" :value="bed.id">
          {{ bed.bed_code }}
        </option>
      </select>

      <button class="confirm-transfer-btn" @click="handleTransfer">
        Confirm Transfer
      </button>
    </div>

    <div class="card">
      <h2>Add New Patient</h2>
      <form @submit.prevent="handleSubmit">

        <!--patients'name-->
        <input
          v-model="form.name"
          placeholder="Patient Name"
          required
          class="input-field"
        />

        <!--date of birth-->
        <input
          type="date"
          v-model="form.dob"
          placeholder="Date of Birth"
          required
          class="input-field"
        />

        <!--choose gender-->
        <select v-model="form.gender" required class="select-field">
          <option disabled value="">Select Gender</option>
          <option value="Male">Male</option>
          <option value="Female">Female</option>
          <option value="Other">Other</option>
        </select>

        <!--assign team-->
        <select v-model="form.team" required class="select-field">
          <option disabled value="">Assign Team</option>
          <option v-for="team in teams" :key="team.id" :value="team.id">
            {{ team.team_code }}
          </option>
        </select>

        <!--select ward-->
        <select v-model="form.ward" required class="select-field">
          <option disabled value="">Select Ward</option>
          <option v-for="ward in wards" :key="ward.id" :value="ward.id">
            {{ ward.ward_code }}
          </option>
        </select>

        <!--bed number-->
        <select v-model="form.bed" required class="select-field">
          <option disabled value="">Select Bed</option>
          <option v-for="bed in beds" :key="bed.id" :value="bed.id">
            {{ bed.bed_code }}
          </option>
        </select>
        <button type="submit">Add Patient</button>
      </form>


      <!--display current patients-->
      <h2>Current Patients</h2>
      <div class="patient-list">
        <div
          v-for="patient in patients"
          :key="patient.id"
          class="patient-card"
          :class="{ selected: selectedPatients.includes(patient.id) }"
        >
          <div class="patient-info">
            <p><strong>Name:</strong> {{ patient.name }}</p>
            <p><strong>DOB:</strong> {{ new Date(patient.dob).toISOString().split('T')[0] }}</p>
            <p><strong>Gender:</strong> {{ patient.gender }}</p>
            <p><strong>Team:</strong> {{ patient.team }}</p>
            <p><strong>Ward:</strong> {{ patient.ward }}</p>
            <p><strong>Bed:</strong> {{ patient.bed }}</p>
          </div>
          <div class="patient-checkbox-wrapper">
            <input
              type="checkbox"
              :checked="isSelected(patient)"
              @change="toggleSelect(patient)"
              class="patient-checkbox"
            />
            <label class="checkbox-label">Select</label>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      form: { name: "", dob: "", gender: "", team: "", ward: "", bed: "" },
      teams: [], // store fetched team list
      wards: [], // store fetched ward list
      beds: [], // store fetched bed list
      transferWards: [], // store fetched other wards
      transferBeds: [], // store fetched other beds
      patients: [], // list of current patients
      selectedPatients: [], // track selected patient IDs
      showTransfer: false,
      transfer: {
        team: "",
        ward: "",
        bed: "",
        gender: "", // store gender of selected patient
      },
    };
  },
  watch: {
    "form.gender": function () {
      this.fetchAvailableWards(this.form.team, this.form.gender, 'form');
    },
    "form.team": function () {
      this.fetchAvailableWards(this.form.team, this.form.gender, 'form');
    },
    "form.ward": function () {
      this.fetchAvailableBeds(this.form.ward, 'form');
    },
    "transfer.team": function () {
      const currentWard = this.selectedPatients.length > 0 ? this.selectedPatients[0].ward : null;
      this.fetchAvailableWards(this.transfer.team, this.transfer.gender, 'transfer', currentWard);
    },
    "transfer.ward": function () {
      this.fetchAvailableBeds(this.transfer.ward, 'transfer');
    }
  },
  methods: {
    // fetch team list from the backend
    async fetchTeamsList() {
      try {
        const res = await fetch("/api/patients/teams");
        const data = await res.json();
        this.teams = data; // store fetched teams in the component state
      } catch (error) {
        console.error("Error fetching teams:", error);
      }
    },

    // fetch ward list from the backend after gender and team selection for new and transfer
    async fetchAvailableWards(teamId, gender, target = 'form', excludeWardId = null) {
      if (teamId && gender) {
        try {
          let url = `/api/patients/wards?team=${teamId}&gender=${gender}`;
          if (excludeWardId) {
            url += `&excludeWard=${excludeWardId}`;
          }
          const res = await fetch(url);
          const data = await res.json();

          if (target === 'form') {
            this.wards = data;
          } else if (target == 'transfer') {
            this.transferWards = data;
          }
        } catch (error) {
          console.error("Error fetching wards:", error);
        }
      }
    },

    // fetch bed list from the backend after ward selection
    async fetchAvailableBeds(wardId, target = 'form') {
      if (wardId) {
        try {
          const res = await fetch(`/api/patients/beds?ward=${wardId}`);
          const data = await res.json();
          if (target == 'form') {
            this.beds = data;
          } else if (target === 'transfer') {
            this.transferBeds = data;
          }
        } catch (error) {
          console.error("Error fetching beds:", error);
        }
      }
    },

    // add new patients to database
    async handleSubmit() {
      try {
        const res = await fetch('/api/patients/newpatients', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(this.form),
        });
        
      if (!res.ok) throw new Error('Failed to add patient');
      
      const result = await res.json();
      alert(`Patient added successfully! ID: ${result.patientId}`);

      // Reset form
      this.form = {
        name: "",
        dob: "",
        gender: "",
        team: "",
        ward: "",
        bed: "",
      };
    } catch (error) {
      console.error('Error submitting form:', error);
      alert('Error adding patient. Please try again.');
    }
    await this.fetchPatients();
  },


    // list all patients
    async fetchPatients() {
        try {
            const res = await fetch('/api/patients/allcurrent');
            const data = await res.json();
            this.patients = data;
        } catch (error) {
            console.error ('Error fetching patients:', error);
        }
    },

    // toggle selection of a patient
    toggleSelect(patient) {
    // If the clicked patient is already selected, deselect them
      if (this.selectedPatients.length === 1 && this.selectedPatients[0].id === patient.id) {
        this.selectedPatients = [];
        this.transfer.gender = "";
      } else {
    // Replace with the newly selected patient
        this.selectedPatients = [patient];
        this.transfer.gender = patient.gender;
      }
    },

    isSelected(patient) {
      return this.selectedPatients.length === 1 && this.selectedPatients[0].id === patient.id;
    },


    // handle transfer confirmation
    handleTransfer() {
      if (
        this.transfer.team &&
        this.transfer.ward &&
        this.transfer.bed &&
        this.selectedPatients.length > 0
      ) {
        // Here you would typically send the transfer data to the backend
        alert(
          `Transferred patients: ${this.selectedPatients.join(", ")} to Team: ${
            this.transfer.team
          }, Ward: ${this.transfer.ward}, Bed: ${this.transfer.bed}`
        );
        this.showTransfer = false; // hide transfer form after submission
        alert("Selected patients transferred successfully.");
      } else {
        alert("Please select patients and fill all transfer details.");
      }
    }
  },

  mounted() {
    this.fetchTeamsList();
    this.fetchPatients();
  }
};
</script>
