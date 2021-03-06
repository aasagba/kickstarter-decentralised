const HDWalletProvider = require('truffle-hdwallet-provider');
const Web3 = require('web3');
const compiledFactory = require('./build/CampaignFactory.json');

// const provider = new HDWalletProvider(
//     'dynamic cube lounge chunk link random filter cancel grow deer unhappy arctic',
//     'https://rinkeby.infura.io/v3/49718db073eb4fa4bf9e76e9e4308b6e'
// );

// connect to target network via infura and unlock account for use on it
const provider = new HDWalletProvider(
);

// feed provider to web3 instance
const web3 = new Web3(provider);

const deploy = async () => {
    const accounts = await web3.eth.getAccounts();

    console.log('Attempting to deploy from account', accounts[0]);

    const result = await new web3.eth.Contract(JSON.parse(compiledFactory.interface))
    .deploy({ data: '0x' + compiledFactory.bytecode })
    .send({ from: accounts[0] })
    .catch(e => {
        // console.error(e);
        throw new Error(e);
    });
    
    console.log('Contract deployed to', result.options.address);
};
deploy();


// const result = await new web3.eth.Contract(JSON.parse(compiledFactory.interface))
//     .deploy({ data: '0x' + compiledFactory.bytecode }) // add bytecode
//     .send({ from: accounts[0] }); // remove gas