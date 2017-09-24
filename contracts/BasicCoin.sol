pragma solidity ^0.4.16;

contract BasicCoin {
    // This creates an array with all balances
    mapping (address => uint256) public balanceOf;
    address public owner;

    // Initializes contract with initial supply tokens to the creator of the contract
    function BasicCoin(uint256 initialSupply) {
        balanceOf[msg.sender] = initialSupply; // Give the creator all initial tokens
        owner = msg.sender;              
    }

    // Send coins
    function transfer(address _to, uint256 _value) {
        require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
        require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
        balanceOf[msg.sender] -= _value;                    // Subtract from the sender
        balanceOf[_to] += _value;                           // Add the same to the recipient
    }

    //whoAmI
    function whoAmI() returns (address){
    	return msg.sender;
    }

    // Get balance
	function getBalance(address addr) returns(uint) {
		return balanceOf[addr];
	}

	/* The function without name is the default function that is called whenever anyone sends funds to a contract */
    function () payable{
        owner.send(msg.value);
        balanceOf[msg.sender] = balanceOf[msg.sender] + msg.value;
    }
}