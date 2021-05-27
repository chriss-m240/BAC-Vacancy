<template>
  <router-view> </router-view>
</template>

<script>
import Web3 from "web3";
import Vacancy from "../truffle/build/contracts/Vacancy.json";

export default {
  name: "App",
  methods: {
    async loadWeb3() {
      if (window.ethereum) {
        window.web3 = new Web3(window.ethereum);
        await window.ethereum.enable();
      } else if (window.web3) {
        window.web3 = new Web3(window.web3.currentProvider);
      } else {
        window.alert("Non-Ethereum browser detected.");
      }
    },

    async loadBloackchainData() {
      const web3 = window.web3;
      const networkId = await web3.eth.net.getId();
      const networkData = Vacancy.networks[networkId];
            const accounts = await web3.eth.getAccounts();

      console.log(accounts)

      if (networkData) {
        const vacancy = await new web3.eth.Contract(
          Vacancy.abi,
          process.env.VUE_APP_CONTRACT_ADDRESS
        );
        console.log(vacancy);
      } else {
        window.alert("Vacancy contract not deployed to detected network");
      }
    },
  },
  async mounted() {
    await this.loadWeb3();
    await this.loadBloackchainData();
  },
};
</script>

<style>
body,
html {
  height: 100%;
  margin: 0px;
}

#app {
  height: 100%;
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #ffff;
}
</style>
