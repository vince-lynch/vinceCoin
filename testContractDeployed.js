var Web3 = require('web3');
var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

var addressOfContract = '0x3d25484c281d2b5adbf8c8f812a080e933ba7c4f';
var jsonAbi = [{"constant":false,"inputs":[{"name":"amount","type":"uint256"},{"name":"conversionRate","type":"uint256"}],"name":"convert","outputs":[{"name":"convertedAmount","type":"uint256"}],"payable":false,"stateMutability":"nonpayable","type":"function"}]



var VotingContract = web3.eth.contract(jsonAbi);
var contractInstance = VotingContract.at(addressOfContract);

console.log('list of functions', contractInstance)

// Doing an example function
contractInstance.convert.call(100,5)