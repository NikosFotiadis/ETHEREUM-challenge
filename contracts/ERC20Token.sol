pragma solidity ^0.4.17;

contract ownedContract {
  address public owner;

  constructor () public {
    owner = msg.sender;
  }

  function transferContrac(address newOwner) public ownerOnly{
    owner = newOwner;
  }

  modifier ownerOnly {
    require(msg.sender == owner);
    _;
  }
}

contract ERC20Token{
  // Tokens name
  string public name;
  string public symbol;

  // Number of token decimals.
  // 18 so because that is the number of 0 1 ether has when
  // converted to wei
  uint8 public decimals = 18;

  // The total supply of the token
  uint256 public totalSupply;

  // Array with the balance of users
  mapping (address => uint256) public balanceOf;
  mapping (address => mapping (address => uint256)) public allowance;

  // Generates an event on the blockchain to notify clients about the transfer
  event Transfer(address indexed from, address indexed to, uint256 value);

  constructor(string _name, string _symbol, uint256 _initialSupply) public {

    name = _name;
    symbol = _symbol;
    totalSupply = _initialSupply * 10 ** uint256(decimals);

    // The creator of the token has all of the tokens uppon creation
    balanceOf[msg.sender] = totalSupply;
  }

  /*
   * Transfers 'value' tokens from 'from' to 'to'
   */
  function InternalTransfer(address from, address to, uint256 value) internal {
    // Users can not destroy tokens
    require(to != 0x0);

    // Users cant send more than they have
    require(balanceOf[from] >= value);

    // Make sure there is no overflow
    require(balanceOf[to] + value >= balanceOf[to]);

    // Transfer 'value' tokens from sender to reciever
    balanceOf[from] -= value;
    balanceOf[to] += value;

    emit Transfer(msg.sender, to, value);
  }

  /*
   * Transfers value tokens from your account to 'to'
   */
  function transfer(address to, uint256 value) public {
    InternalTransfer(msg.sender, to, value);
  }

  /*
   * Transfer tokens from another address
   * You must have allowance to transfer from that address
   */
  function transferFrom(address from, address to, uint256 value) public returns (bool success){
    // Check if there is allowance
    require(value <= allowance[from][msg.sender]);

    // Substract the amount transfered from the allownace
    allowance[from][msg.sender] -= value;

    InternalTransfer(from, to, value);
    return(true);
  }

  /*
   * Set allownace on your account for anther user
   */
   function approve(address spender, uint256 value) public returns (bool success){
     allowance[msg.sender][spender] = value;
     return true;
   }
}

contract ErcTokenFON is ownedContract, ERC20Token{

  // Token price in wei
  uint256 public tokenPrice;

  constructor (string name, string symbol, uint256 initialSupply, uint256 initialPrice) ERC20Token(name,symbol,initialSupply) public {
    tokenPrice = initialPrice;
  }

  function transfer(address to, uint256 ammount) public {
    InternalTransfer(msg.sender,to,ammount);
  }

  function () payable public {
    uint ammount = msg.value / tokenPrice;
    require(ammount <= balanceOf[owner]);
    InternalTransfer(owner,msg.sender,ammount);
  }

  function setTokenPrice(uint256 newPrice) public ownerOnly {
     tokenPrice = newPrice;
  }
}
