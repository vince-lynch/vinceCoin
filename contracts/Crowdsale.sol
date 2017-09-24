//https://github.com/ethereum/go-ethereum/wiki/Contract-Tutorial#the-code-1

/*
Vince Lynch @vince-lynch 11:31
Hey, been writing smart contracts for a few days now, using the testrpc node package, and solidity with web3.eth, I have a few questions.
If I make a token. How do I accept ether deposit and then automatically return with the token amount (or update the balance of the user).
Just to be clear, I know how to update the balance, but whenever I use web3.eth.sendTranaction({from: addressofUser, to: addressofContract, value: 100})
Then I check balance, The balance hasn't been updated. its like it never saw the incoming ether?

ajlopez @ajlopez 11:39
@vince-lynch "The function without name is the default function that is called whenever anyone sends funds to a contract"

Vince Lynch @vince-lynch 11:42
Thanks @ajlopez - and these funds can be sent just as a normal transaction like you would send to an ether wallet. But in this case the address they are sending to is the address of the contract, and then I just update their balance (+ post the event) ?

ajlopez @ajlopez 11:49
@vince-lynch yes, and the function without name should update the internal token balance of the msg.sender, but I'm not sure the meaning of "I check the balance, and it is not updated". To me, it is the internal token balance, a map of addresses to values inside the contract


Vince Lynch @vince-lynch 11:54
@ajlopez I think I understand, but which is the line that passes the Eth deposited (to the contract) to the contract owner (defined in the constructor function)

ajlopez @ajlopez 11:59
@vince-lynch ah! there is no such line in the example. Only the function without name, where you must write your own logic. The Eth send to that function is assigned to the public balance in ETH of the contract. Internally, the token balance of the owner of the contract should be decremented by the msg.value (I guess 1 to 1 conversion), and the token balance of the sender should be incremented in the same amount. You save msg.sender in the constructor to "owner" contract variable. Then, the code could be

Vince Lynch @vince-lynch 12:00
beneficiary.send(amountRaised);
.send is a function of address -> and the amount is always eth

ajlopez @ajlopez 12:11
@vince-lynch I forgot to mention that function without name should have payable as modifier in order to accept ether, see https://ethereum.stackexchange.com/questions/9242/if-i-try-to-send-to-send-ether-to-the-standard-token-contract-the-tx-is-rejecte

If you are using Solidity >= 0.4, you will need to add payable to the function for it to accept Ether.

function() payable {
    amount += msg.value;
}


    function () payable{
        owner.send(msg.value);
        balanceOf[msg.sender] = balanceOf[msg.sender] + msg.value;
    }

*/
contract token {
 mapping (address => uint) public coinBalanceOf;

    function token() {

    }  
    
    function sendCoin(address receiver, uint amount) returns(bool sufficient) {

    } 
}

contract Crowdsale {
    
    address public beneficiary;
    uint public fundingGoal; uint public amountRaised; uint public deadline; uint public price;
    token public tokenReward;   
    Funder[] public funders;
    event FundTransfer(address backer, uint amount, bool isContribution);
    
    /* data structure to hold information about campaign contributors */
    struct Funder {
        address addr;
        uint amount;
    }
    
    /*  at initialization, setup the owner */
    function Crowdsale(address _beneficiary, uint _fundingGoal, uint _duration, uint _price, token _reward) {
        beneficiary = _beneficiary;
        fundingGoal = _fundingGoal;
        deadline = now + _duration * 1 minutes;
        price = _price;
        tokenReward = token(_reward);
    }   
    
    /* The function without name is the default function that is called whenever anyone sends funds to a contract */
    function () {
        uint amount = msg.value;
        funders[funders.length++] = Funder({addr: msg.sender, amount: amount});
        amountRaised += amount;
        tokenReward.sendCoin(msg.sender, amount / price);
        FundTransfer(msg.sender, amount, true);
    }
        
    modifier afterDeadline() { if (now >= deadline) _ }

    /* checks if the goal or time limit has been reached and ends the campaign */
    function checkGoalReached() afterDeadline {
        if (amountRaised >= fundingGoal){
            beneficiary.send(amountRaised);
            FundTransfer(beneficiary, amountRaised, false);
        } else {
            FundTransfer(0, 11, false);
            for (uint i = 0; i < funders.length; ++i) {
              funders[i].addr.send(funders[i].amount);  
              FundTransfer(funders[i].addr, funders[i].amount, false);
            }               
        }
        suicide(beneficiary);
    }
}