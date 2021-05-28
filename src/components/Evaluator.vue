<template>
  <div class="landing">
    <div class="centered-div">
      <h1>¡Evaluemos!</h1>
      <p>
        Cambiemos a un rol de <b>evaluador</b>. Una vez tenemos aplicantes
        podemos evaluarlos. Por favor selecciona uno y asignale un puntaje.
      </p>
      <a href="cierre" class="custom-btn">Continuar</a>
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
            <p>{{ applicant.bio }}</p>
            <p>{{ applicant.skillsAchievementsInfo }}</p>
          </div>
        </div>
      </div>
      <modal name="evaluation" width="50%" height="auto">
        <div class="evaluation-modal-header">
          <h3>EVALUAR USUARIO</h3>
        </div>
        <div class="modal-content">
          <p>
            Al evaluar un usuario se abrirá la ventana de <b>Metamask</b> para
            asignar un valor, ten en cuenta que debe ser menor o igual que 100
          </p>
          <form>
            <label for="score"><b>Puntaje</b></label>
            <input
              type="text"
              id="score"
              name="score"
              placeholder="Ingresa el puntaje a asignar (0 a 100)..."
              v-model="score"
            />
          </form>
          <a class="custom-btn" @click="evaluate()">Enviar</a>
        </div>
      </modal>
      <modal name="error" width="50%" height="auto">
        <div class="error-modal-header">
          <h3>ERROR</h3>
        </div>
        <div class="modal-content">
          <p>Se presento un error. Considera lo siguiente:</p>
          <p>
            * Estar con el rol o cuenta correspondiente para la acción (Solo un
            evaluador puede evaluar)
          </p>
          <p>* Solo se puede asignar por mucho 100 puntos por evaluación</p>
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
    vacancy: undefined,
    applicants: [],
    score: undefined,
    index: undefined,
  }),

  async mounted() {
    this.vacancy = await new web3.eth.Contract(
      Vacancy.abi,
      process.env.VUE_APP_CONTRACT_ADDRESS
    );

    const n = await this.vacancy.methods.applicantCount().call();
    const vacancyVersion = await this.vacancy.methods.vacancyVersion().call();

    for (let i = 1; i <= n; i++) {
      const applicant = await this.vacancy.methods
        .applicants(i + parseInt(vacancyVersion))
        .call();
      this.applicants.push({
        name: applicant.name,
        bio: applicant.bio,
        skillsAchievementsInfo: applicant.skillsAchievementsInfo,
      });
    }
  },

  methods: {
    showModal(index) {
      this.index = index;
      this.$modal.show("evaluation");
    },
    async evaluate() {
      const tx = this.vacancy.methods.evaluateUser(this.index + 1);

      let err = await this.$store.dispatch("sendTransaction", {
        web3: web3,
        tx: tx,
        isPayable: true,
        value: this.score,
      });

      if (err) {
        this.$modal.hide("evaluation");
        this.$modal.show("error");
        return;
      }

      this.$modal.hide("evaluation");
    },
  },
};
</script>

<style scoped>
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

.evaluation-modal-header {
  background-color: #4412c9;
  height: 50%;
  color: #ffffff;
  padding: 15px;
}

.error-modal-header {
  background-color: crimson;
  height: 50%;
  color: #ffffff;
  padding: 15px;
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
</style>
