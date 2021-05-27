const mutations = {
    account(state, _account) {
        state.account = _account;
    },
    contract(state, _contract) {
        console.log(_contract)
        state.contract = _contract;
    },
};

export default mutations;
