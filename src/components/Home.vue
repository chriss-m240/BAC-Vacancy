<template>
  <div class="landing">
    <div class="centered-div">
      <h1>¡Iniciemos!</h1>
      <p>Recuerda estar conectado a la red de prueba de KOVAN.</p>
      <p>
        Actualmente estamos con un rol de <b>usuario</b>, la aplicación simula
        un proceso de selección de aspirantes a una vacante. <b>Nota:</b> Aplica
        con dos usuarios antes de continuar.
      </p>
      <a class="custom-btn" @click="modal()">Aplica</a>
      <a class="custom-btn" @click="next()">Continuar</a>
      <modal name="application-form" width="50%" height="auto">
        <div class="modal-header">
          <h3>FORMULARIO DE APLICACIÓN</h3>
        </div>

        <div class="modal-content">
          <form>
            <label for="name"><b>Nombre</b></label>
            <input
              type="text"
              id="name"
              name="name"
              placeholder="Tu nombre..."
              v-model="name"
            />

            <label for="bio"><b>Bio</b></label>
            <input
              type="text"
              id="bio"
              name="bio"
              placeholder="Una breve descripción de ti..."
              v-model="bio"
            />

            <label for="skillsAchievementsInfo"><b>Habilidades y logros</b></label>
            <input
              type="text"
              id="skillsAchievementsInfo"
              name="skillsAchievementsInfo"
              placeholder="Lista tus habilidades y logros..."
              v-model="skillsAchievementsInfo"
            />

            <label for="salary"><b>Salario tentativo</b></label>
            <input
              type="number"
              id="salary"
              name="salary"
              placeholder="Ingresa un valor tentativo de salario..."
              v-model="salary"
            />

            <a class="custom-btn" @click="apply()">Enviar</a>
          </form>
        </div>
      </modal>
      <modal name="error" width="50%" height="auto">
        <div class="error-modal-header">
          <h3>ERROR</h3>
        </div>
        <div class="modal-content">
          <p>Se presento un error. Considera lo siguiente:</p>
          <p>* Un usuario solo puede aplicar una vez</p>
          <p>
            * Estar con el rol o cuenta correspondiente para la acción (Solo
            usuarios registrados pueden aplicar)
          </p>
          <p>* La vacante no esta abierta</p>
        </div>
      </modal>
      <div class="card-container">
        <div class="card" v-for="(applicant, index) in applicants" :key="index">
          <img src="../assets/user_icon.jpg" style="width: 100%" />
          <div class="container">
            <h4>
              <b>{{ applicant.name }}</b>
            </h4>
            <p>{{ applicant.bio }}</p>
            <p>{{ applicant.skillsAchievementsInfo }}</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Vacancy from "../../truffle/build/contracts/Vacancy.json";

const web3 = window.web3;

export default {
  name: "Home",
  props: {
    msg: String,
  },

  data: () => ({
    vacancy: undefined,
    name: undefined,
    bio: undefined,
    skillsAchievementsInfo: undefined,
    salary: undefined,
    applicants: [],
  }),

  async mounted() {
    this.vacancy = await new web3.eth.Contract(
      Vacancy.abi,
      process.env.VUE_APP_CONTRACT_ADDRESS
    );

    const n = await this.vacancy.methods.applicantCount().call();
    const vacancyVersion = await this.vacancy.methods.vacancyVersion().call();

    console.log(n);
    console.log(vacancyVersion);

    for (let i = 1; i <= n; i++) {
      const applicant = await this.vacancy.methods
        .applicants(i + parseInt(vacancyVersion))
        .call();
      this.applicants.push({
        name: applicant.name,
        bio: applicant.bio,
        skillsAchievementsInfo: applicant.skillsAchievementsInfo,
        salary: applicant.salary,
      });
    }
  },

  methods: {
    modal: function () {
      this.$modal.show("application-form");
    },
    next: function () {
      if (this.applicants.length < 2) {
        window.alert("Aplica con dos usuarios antes de continuar");
        return;
      }
      this.$router.push({ path: "evaluacion" });
    },
    apply: async function () {
      const tx = this.vacancy.methods.addApplicant(
        this.name,
        this.bio,
        this.skillsAchievementsInfo,
        parseInt(this.salary)
      );

      let err = await this.$store.dispatch("sendTransaction", {
        web3: web3,
        tx: tx,
        isPayable: false,
      });
      console.log(err);
      if (err) {
        this.$modal.hide("application-form");
        this.$modal.show("error");
        return;
      }

      this.$modal.hide("application-form");
      this.applicants.push({
        name: this.name,
        bio: this.bio,
        skillsAchievementsInfo: this.skillsAchievementsInfo,
      });

      console.log(this.applicants);
    },
  },
};
</script>

<style scopped>
.landing {
  height: 100%;
  background-image: url("../assets/background.jpg");
  /* background-image: url("../assets/landing_page.jpg"); */
  background-position: center;
  background-repeat: no-repeat;
  background-size: cover;

  position: relative;
}

.centered-div {
  width: 50px;
  /* height: 50px; */
  margin: auto;
  width: 50%;
  padding: 10px;

  position: absolute;
  top: 15%;
  left: 25%;
  margin-top: -25px;

  /* display: flex; */
  justify-content: center;
}

a.custom-btn {
  display: inline-block;
  padding: 0.5em 3em;
  border: 0.16em solid #4412c9;
  margin: 0 0.3em 0.3em 0;
  box-sizing: border-box;
  text-decoration: none;
  text-transform: uppercase;
  font-weight: 400;
  color: #4412c9;
  text-align: center;
  transition: all 0.15s;
}

a.custom-btn:hover {
  color: #ac3db9;
  border-color: #ac3db9;
  cursor: pointer;
}

a.custom-btn:active {
  color: #bbbbbb;
  border-color: #bbbbbb;
}

input[type="text"],
select {
  width: 100%;
  padding: 12px 20px;
  margin: 8px 0;
  display: inline-block;
  border: 1px solid #ccc;
  border-radius: 4px;
  box-sizing: border-box;
}

input[type="number"],
select {
  width: 100%;
  padding: 12px 20px;
  margin: 8px 0;
  display: inline-block;
  border: 1px solid #ccc;
  border-radius: 4px;
  box-sizing: border-box;
}

.modal-header {
  background-color: #4412c9;
  height: 50%;
  color: #ffffff;
  padding: 15px;
}

.modal-content {
  padding: 15px;
}

h3 {
  margin: 0;
}

.error-modal-header {
  background-color: crimson;
  height: 50%;
  color: #ffffff;
  padding: 15px;
}

.card {
  /* Add shadows to create the "card" effect */
  box-shadow: 0 8px 16px 0 rgba(0, 0, 0, 0.2);
  transition: 0.3s;

  width: 40%;
  margin: 25px;

  border-radius: 25px;
  max-width: 250px;
}

/* On mouse-over, add a deeper shadow */
.card:hover {
  box-shadow: 0 8px 16px 0 rgba(114, 29, 232, 0.7);
}

/* Add some padding inside the card container */
.container {
  padding: 2px 16px;
}

.card-container {
  display: flex;
}
</style>
