const Vacancy = artifacts.require("Vacancy");

module.exports = function (deployer) {
  deployer.deploy(Vacancy, "Vacante de prueba piloto", "Corresponde a una prueba de concepto", 125);
};
