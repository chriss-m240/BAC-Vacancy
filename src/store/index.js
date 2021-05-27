import Vue from 'vue';
import Vuex from 'vuex';
import VuexPersist from 'vuex-persist';

import actions from './actions';
import getters from './getters';
import mutations from './mutations';
import state from './state';

const vuexLocalStorage = new VuexPersist({
  storage: window.localStorage,
});

Vue.use(Vuex);

export default new Vuex.Store({
  state,
  actions,
  mutations,
  getters,
  plugins: [vuexLocalStorage.plugin],
});
