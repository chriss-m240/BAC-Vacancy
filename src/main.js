import Vue from 'vue'
import App from './App.vue'
import router from './router';
import store from './store';
import VModal from 'vue-js-modal'
import dotenv from 'dotenv';

dotenv.config();

Vue.config.productionTip = false

Vue.use(VModal)

new Vue({
  router,
  store,
  render: h => h(App),
}).$mount('#app')
