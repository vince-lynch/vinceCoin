fs = require('fs');
solc = require('solc');
Web3 = require('web3');
web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

var ContactName = 'BasicCoin';
var constructorData = 100;

code = fs.readFileSync('./contracts/'+ ContactName +'.sol').toString();
compiledCode = solc.compile(code);

abiDefinition = JSON.parse(compiledCode.contracts[':' + ContactName].interface);
VotingContract = web3.eth.contract(abiDefinition);
byteCode = compiledCode.contracts[':' + ContactName].bytecode;

deployedContract = VotingContract.new(constructorData,{data: byteCode, from: web3.eth.accounts[0], gas: 4700000});

console.log('abi', compiledCode.contracts[':' + ContactName].interface);
contractInstance = VotingContract.at(deployedContract.address);

console.log('Contract deployed at:', deployedContract.address);
console.log('transactionHash:', deployedContract.transactionHash);

// web3.eth.sendTransaction({from:web3.eth.accounts[0], to: '0xd3a35df9aaba377cc6f0d0fc6ad514625fec3269', value: 55})
//web3.eth.sendTransaction({from:web3.eth.accounts[0], to: deployedContract.address, value: 55})

contractInstance.getBalance.call(web3.eth.accounts[0])

//// or var balance = web3.eth.getBalance(someAddress);
// web3.eth.getBalance(web3.eth.accounts[0]);


/* /// Worked!
> contractInstance.getBalance.call(web3.eth.accounts[0])
{ [String: '100'] s: 1, e: 2, c: [ 100 ] }
> web3.eth.sendTransaction({from:web3.eth.accounts[0], to: deployedContract.address, value: 55})
'0x18a477410ccb6771a75d329dada404e97b5913446525bf676ec90b2f014d6c10'
> contractInstance.getBalance.call(web3.eth.accounts[0])
{ [String: '155'] s: 1, e: 2, c: [ 155 ] }
> web3.eth.getBalance(web3.eth.accounts[0])
{ [String: '99999999999982853120'] s: 1, e: 19, c: [ 999999, 99999982853120 ] }
> 
> 
> web3.eth.sendTransaction({from:web3.eth.accounts[1], to: deployedContract.address, value: 55})
'0x533839694bfdfed4ae67076bde33cc7356442d1f63776cc0654fde0b674191cd'
> web3.eth.getBalance(web3.eth.accounts[0])
{ [String: '99999999999982853175'] s: 1, e: 19, c: [ 999999, 99999982853175 ] }
> web3.eth.sendTransaction({from:web3.eth.accounts[2], to: deployedContract.address, value: 100})
'0x30178b029e294e840c85d3ae7395b86c84ca21fb99894bf3562c361d2f6c084f'
> web3.eth.getBalance(web3.eth.accounts[0])
{ [String: '99999999999982853275'] s: 1, e: 19, c: [ 999999, 99999982853275 ] }
> contractInstance.getBalance.call(web3.eth.accounts[2])
{ [String: '100'] s: 1, e: 2, c: [ 100 ] }
> contractInstance.getBalance.call(web3.eth.accounts[1])
{ [String: '55'] s: 1, e: 1, c: [ 55 ] }

*/
