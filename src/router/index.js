import Vue from 'vue';
import VueRouter from 'vue-router';

Vue.use(VueRouter);

const routes = [
  {
    path: '/',
    name: 'LandingPage',
    component: () => import('@/components/LandingPage.vue'),
  },
  {
    path: '/inicio',
    name: 'Home',
    component: () => import('@/components/Home.vue'),
  },
  {
    path: '/evaluacion',
    name: 'Evaluator',
    component: () => import('@/components/Evaluator.vue'),
  },
  {
    path: '/cierre',
    name: 'Admin',
    component: () => import('@/components/Admin.vue'),
  }
];

const router = new VueRouter({
  routes,
  mode: 'history'
});

export default router;
