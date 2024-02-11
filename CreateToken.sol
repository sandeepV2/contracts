pragma solidity ^0.4.24;

// Transactions carried out with this Contract.
// in Sophalia test net.
// https://sepolia.etherscan.io/token/0x9D1d34E675d5c28a5FAa23ee9A16b2526350284f

contract Token {

    function totalSupply() constant returns (uint256 supply) {}

    function balanceOf(address _owner) constant returns (uint256 balance) {}

    function transfer(address _to, uint256 _value) returns (bool success) {}

    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}

    function approve(address _spender, uint256 _value) returns (bool success){}

    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}

    
    // "INDEXED" keyword: The indexed parameters for logged events will allow you 
    //                       to search for these events using the indexed parameters as filters.
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    
    event Approval(address indexed _owner, address indexed _spender, uint256 _value); 
    
}

// note the inheritence
contract XYZToken is Token {
    
    /* defining datatypes */

    string public name;
    uint8 public decimals;
    string public symbol;
    uint256 public unitsOneEthCanBuy;
    uint256 public totalEthInWei;
    address public fundsWallet;
    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;   //allowed[address1][address2] --> amount of unit allowed by address1 to be used by 
                                                                                                // address 2
    uint256 public totalSupply;


    /* constructor */
    // 1 ETH = 10^18 Wei
    // 1 XYZ = 10^18
    // XYZ: totalSupply/10^decimals
    // XYZDenom : totalSupply
    constructor() public {
        balances[msg.sender] = 1000000000000000000000;  // the least denomination ACTUAL supply : x/10^decimals
        totalSupply = 1000000000000000000000;
        name = "SandeepBToken";
        decimals = 18;
        symbol = "SBT";
        unitsOneEthCanBuy = 10;
        fundsWallet = msg.sender;
    }

    /* main functions */

    function transfer(address _to, uint256 _value) returns (bool success) {
        
        if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            emit Transfer(msg.sender, _to, _value);
            return true;
        } 
        
        else { 
            return false; 
        } 
    }

    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        
        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
            balances[_to] += _value;
            balances[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            emit Transfer(_from, _to, _value);
            return true;
        } 
        else { 
            return false; 
        }
    }

    // constant keyword is the same as "view" keyword for older versions
    function balanceOf(address _owner) constant returns (uint256 balance) {
        return balances[_owner];
    }


    function approve(address _spender, uint256 _value) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner,  address _spender) constant returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }


    function() payable{ // This function is a fallback function
        
        totalEthInWei = totalEthInWei + msg.value;
        
        uint256 amount = msg.value * unitsOneEthCanBuy;
        
        require(balances[fundsWallet] >= amount);
        
        balances[fundsWallet] = balances[fundsWallet] - amount;
        
        balances[msg.sender] = balances[msg.sender] + amount;
        
        emit Transfer(fundsWallet, msg.sender, amount);
        
        fundsWallet.transfer(msg.value);
    } 
}
