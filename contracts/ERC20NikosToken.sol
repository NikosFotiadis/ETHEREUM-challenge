pragma solidity ^0.4.17;


contract ERC20NikosToken{
  // Tokens name
  string public name;
  string public symbol;

  // Number of token decimals.
  // 18 so because that is the number of 0 1 ether has when
  // converted to wei
  uint8 public decimals = 18;

  // The total supply of the token
  uint256 public totalSupply;

  // The initial supply of the token
  uint256 public initialSupply;

  // How much ether does on token costs
  // Can be set by the token administrator
  uint tokenPrice = 1000000000000000; //1.000.000.000.000.000

  // Manager of the token
  public address manager;

  uint256 public bankBalance;

  // Array with the balance of users
  mapping (address => uint256) public balanceOf;
  mapping (address => mapping (address => uint256)) public allowance;

  // Generates an event on the blockchain to notify clients about the transfer
  event Transfer(address indexed from, address indexed to, uint256 value);

  constructor(string _name, string _symbol, uint256 _initialSupply) public {
    manager = msg.sender;

    name = _name;
    symbol = _symbol;
    initialSupply = _initialSupply * 10 ** uint256(decimals);
    totalSupply = initialSupply;
    bankBalance = initialSupply;

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

   /*
    * Buy 'amount' amount Tokens
    * User must pay in ether according to the token price
    */
   function buy(uint256 amount) public payable {
       require(msg.value == (amount * tokenPrice));
       balanceOf[msg.sender] += amount;
   }

   /*
    * Create 'amount' new tokens
    * Only the manager can call this function
    */
   function createTokens(uint256 amount) public managerOnly {
     bankBalance += ammmount;
   }

   modifier managerOnly() {
     require(msg.sender == manager);
     _;
   }

}
