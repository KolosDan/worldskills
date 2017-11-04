pragma solidity ^0.4.0;
import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";
contract permissions is usingOraclize
{
    address owner = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    address admin;
    
    function changeOwner(address newOwner) onlyOwner
{
    owner = newOwner;
}

    modifier onlyOwner() 
{
    require(msg.sender == owner);
    _;
}
    modifier onlyAdmin()
{
    require(msg.sender == admin);
    _;
}
}


contract kekoin is permissions
{
    string public constant name = "kekoin";
    string public constant symbol = "KEK";
    uint8 public constant decimals = 18;
    uint public coef = 1000000000000;

    uint public totalSupply = 13372280;

    mapping (address => uint) balances;
    mapping (address => mapping (address => uint)) allowed;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
    

    function balanceOf(address _owner) constant returns (uint256 balance)
{
    return balances[_owner];
}

    function transfer(address _to, uint256 _value) returns (bool success)
{
    if (balances[msg.sender]>=_value && _value >0 && balances[_to] + _value >= balances[_to])
{
    balances[msg.sender] -= _value;
    balances[_to] += _value;
    Transfer(msg.sender, _to, _value);
    return true;
}
    else {return false;}
}

    function transferFrom(address _from, address _to, uint _value) returns (bool success)
{
    if( allowed[_from][msg.sender] >= _value &&
    balances[_from] >= _value
    && balances[_to] + _value >= balances[_to]) {
    allowed[_from][msg.sender] -= _value;
    balances[_from] -= _value;
    balances[_to] += _value;
    Transfer(_from, _to, _value);
    return true;
}
    return false;
}

    function approve(address _spender, uint _value) returns (bool success)
{
    allowed[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);
    return true;
}

    function allowance(address _owner, address _spender) constant returns (uint remaining)
{
    return allowed[_owner][_spender];

}

    function mint(address _to, uint _value) onlyOwner
{
    assert(totalSupply + _value >= totalSupply && balances[_to] + _value >= balances[_to]);
    balances[_to] += _value;
    totalSupply += _value;
}
    function getPrice()
    {
        oraclize_query('URL',"html(https://myfin.by/crypto-rates/ethereum-rub).xpath(//*[contains(@class, 'birzha_info_head_rates')]/text())");
    
    }


    function() external payable
{
   
    owner.transfer(msg.value);
    uint buy = msg.value / coef;
    if(buy < totalSupply){  
    totalSupply -= buy;
    balances[msg.sender] += buy;
    }
    else {msg.sender.transfer(msg.value);}
}
    function changeCoef(uint newCoef) onlyOwner onlyAdmin
    {
        coef = newCoef;
    }

}

