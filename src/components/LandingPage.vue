<template>
  <div class="landing">
    <div class="centered-div">
      <h1>Bienvenido</h1>
      <p>
        Esta es una dapp (aplicación descentralizada) desarrollada como proyecto
        de certificación del curso de Programación de Contratos Inteligentes con
        Solidity de <b>Blockchain Academy Chile</b>.
      </p>
      <p>
        <b>NOTA:</b> Antes de comenzar por favor registra tu cuenta como rol de
        usuario o de evaluador.
      </p>
      <a class="custom-btn" @click="registerUser()">Registar usuario</a>
      <a class="custom-btn" @click="registerEvaluator()">Registar evaluador</a>
      <a href="inicio" class="custom-btn">Comenzar</a>
    </div>
  </div>
</template>

<script>
import Vacancy from "../../truffle/build/contracts/Vacancy.json";

const web3 = window.web3;

export default {
  name: "LandingPage",

  data: () => ({
    vacancy: undefined,
  }),

  async mounted() {
    this.vacancy = await new web3.eth.Contract(
      Vacancy.abi,
      process.env.VUE_APP_CONTRACT_ADDRESS
    );
  },

  methods: {
    registerUser: async function () {
      const accounts = await web3.eth.getAccounts();

      const tx = this.vacancy.methods.registerAsUser(accounts[0]);

      await this.$store.dispatch("sendTransaction", {
        web3: web3,
        tx: tx,
        isPayable: false,
      });
    },
    registerEvaluator: async function () {
      const accounts = await web3.eth.getAccounts();

      const tx = this.vacancy.methods.registerAsEvaluator(accounts[0]);

      await this.$store.dispatch("sendTransaction", {
        web3: web3,
        tx: tx,
        isPayable: false,
      });
    },
  },
};
</script>

<style scoped>
.landing {
  height: 100%;
  /* background-image: url("../assets/background.jpg"); */
  background-image: url("../assets/landing_page.jpg");

  background-position: center;
  background-repeat: no-repeat;
  background-size: cover;

  position: relative;
}

.centered-div {
  color: #ffff;

  width: 50px;
  /* height: 50px; */
  margin: auto;
  width: 50%;
  padding: 10px;

  position: absolute;
  top: 25%;
  left: 25%;
  margin-top: -25px;

  /* display: flex; */
  /* justify-content: center; */
  align-content: center;
}

a.custom-btn {
  display: inline-block;
  padding: 0.5em 3em;
  border: 0.16em solid #ffffff;
  margin: 0 0.3em 0.3em 0;
  box-sizing: border-box;
  text-decoration: none;
  text-transform: uppercase;
  font-weight: 400;
  color: #ffffff;
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
</style>
