
const actions = {
    async sendTransaction(_, _params) {
        try {
            const web3 = _params.web3;

            const accounts = await web3.eth.getAccounts();
            const networkId = await web3.eth.net.getId();

            let gas = await _params.tx.estimateGas({ from: accounts[0] });
            gas = gas * 2;
            const gasPrice = await web3.eth.getGasPrice();
            const data = _params.tx.encodeABI();
            const nonce = await web3.eth.getTransactionCount(accounts[0]);

            const signedTx = (_params.isPayable)? {
                from: accounts[0],
                to: process.env.VUE_APP_CONTRACT_ADDRESS,
                data,
                gas,
                gasPrice,
                nonce,
                chainId: networkId,
                value: _params.value,
            } : {
                from: accounts[0],
                to: process.env.VUE_APP_CONTRACT_ADDRESS,
                data,
                gas,
                gasPrice,
                nonce,
                chainId: networkId,
            };

            const receipt = await web3.eth.sendTransaction(signedTx);
            console.log("Tx hash", receipt.transactionHash);
            console.log("Tx hash", receipt);
            return false;
        } catch (err) {
            console.error(err)
            return true;
        }
    }
};

export default actions;
