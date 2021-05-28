<template>
  <div class="landing">
    <div class="centered-div">
      <h1>¡Hora de la selección!</h1>
      <p>
        Finalizado el proceso de evaluación, como
        <b> administadores </b> tenemos que seleccionar los mejores aspirantes
        para la vacante. Para ello, tras cerrar la convocatoria, veremos
        aquellos quienes hayan superado el puntaje mínimo - como prueba de
        concepto se consideraron <b>125 puntos</b> -.
      </p>
      <p>
        Cierra la convocatoria y mira cuáles aspirantes pasaron. Luego intenta
        abriendo una nueva vancate y postular nuevos candidatos
      </p>
      <a class="custom-btn" @click="closeVacancy()"> Cerrar</a>
      <a class="custom-btn" @click="openVacancy()"> Abrir nueva vacante</a>

      <div class="card-container">
        <div
          class="card"
          v-for="(applicant, index) in applicants"
          :key="applicant.name"
          @click="showModal(index)"
        >
          <img src="../assets/user_icon.jpg" style="width: 100%" />
          <div class="container">
            <h4>
              <b>{{ applicant.name }}</b>
            </h4>
            <p><b>Puntaje:</b> {{ applicant.score }}</p>
            <p><b>Salario Tentativo:</b> {{ parseInt(applicant.salary)/(parseInt(applicant.currentEthValue)/(10**8))}} Eth</p>
          </div>
        </div>
      </div>
      <p v-if="none">Ningún candidato superó el puntaje establecido.</p>

      <modal name="error" width="50%" height="auto">
        <div class="error-modal-header">
          <h3>ERROR</h3>
        </div>
        <div class="modal-content">
          <p>Se presento un error. Considera lo siguiente:</p>
          <p>
            * Estar con el rol o cuenta correspondiente para la acción (Solo el
            admin puede realizar acciones en esta pantalla)
          </p>
        </div>
      </modal>
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
    none: false,
    vacancy: undefined,
    applicants: [],
    treshold: undefined,
  }),

  async mounted() {
    this.vacancy = await new web3.eth.Contract(
      Vacancy.abi,
      process.env.VUE_APP_CONTRACT_ADDRESS
    );

    this.treshold = await this.vacancy.methods.treshold().call();
  },

  methods: {
    async closeVacancy() {
      const tx = this.vacancy.methods.closeVacancy();

      let err = await this.$store.dispatch("sendTransaction", {
        web3: web3,
        tx: tx,
        isPayable: false,
      });

      if (err) {
        this.$modal.show("error");
        return;
      }

      const n = await this.vacancy.methods.applicantCount().call();
      const vacancyVersion = await this.vacancy.methods.vacancyVersion().call();

      for (let i = 1; i <= n; i++) {
        const applicant = await this.vacancy.methods
          .applicants(i + parseInt(vacancyVersion))
          .call();
        if (applicant.score >= this.treshold) {
          this.applicants.push({
            name: applicant.name,
            bio: applicant.bio,
            skillsAchievementsInfo: applicant.skillsAchievementsInfo,
            score: applicant.score,
            currentEthValue: applicant.currentEthValue,
            salary: applicant.salary,
          });
        }
      }

      this.none = this.applicants.length == 0;
    },
    async openVacancy() {
      const tx = this.vacancy.methods.openVacancy();

      let err = await this.$store.dispatch("sendTransaction", {
        web3: web3,
        tx: tx,
        isPayable: false,
      });

      if (err) {
        this.$modal.show("error");
        return;
      }
      this.$router.push({ path: "/" });
    },
  },
};
</script>

<style scoped>
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
}

a.custom-btn:active {
  color: #bbbbbb;
  border-color: #bbbbbb;
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
</style>
