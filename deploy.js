const HDWalletProvider = require('truffle-hdwallet-provider');
const Web3 = require('web3');
const {interface, bytecode} = require('./compile');
const assert = require('assert');

const provider = new HDWalletProvider(  'remind pact rally demise bless way worry element panel tiger advance diesel',
                                        'https://rinkeby.infura.io/1P0WrFGUx77xRKxQj368');

const web3 = new Web3(provider);

let result;
let accounts;

const deploy = async () => {
  accounts = await web3.eth.getAccounts();

  console.log('Attempting to deploy from account : '+accounts[0]);

  result = await new web3.eth.Contract(JSON.parse(interface))
    .deploy({ data: bytecode, arguments: ['tokenTest',1000,] })
    .send({ gas: '1000000', from: accounts[0] });

  console.log('Contract deployed to '+result.options.address);
};

deploy();
