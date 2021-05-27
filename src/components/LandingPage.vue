<template>
  <div class="landing">
    <div class="centered-div">
      <h1>
        Bienvenido
      </h1>
      <p>
        Esta es una dapp (aplicación descentralizada) desarrollada como proyecto
        de certificación del curso de Programación de Contratos Inteligentes con
        Solidity de <b>Blockchain Academy Chile</b>.
      </p>
      <a href="inicio" class="custom-btn">Comenzar</a>
    </div>
  </div>
</template>

<script>
export default {
  name: "LandingPage",
  props: {
    msg: String,
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
  top: 35%;
  left: 25%;
  margin-top: -25px;

  /* display: flex; */
  /* justify-content: center; */
  align-content: center;
}

a.custom-btn {
  display: inline-block;
  padding:0.5em 3em;
  border:0.16em solid #FFFFFF;
  margin:0 0.3em 0.3em 0;
  box-sizing: border-box;
  text-decoration:none;
  text-transform:uppercase;
  font-weight:400;
  color:#FFFFFF;
  text-align:center;
  transition: all 0.15s;
}

a.custom-btn:hover {
  color: #AC3DB9;
  border-color: #AC3DB9;
}

a.custom-btn:active{
  color:#BBBBBB;
  border-color:#BBBBBB;
}
</style>
