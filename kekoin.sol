pragma solidity ^0.4.0;
//import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";
contract permissions
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
    require(msg.sender == admin || msg.sender == owner);
    _;
}
}


contract kekoin is permissions
{
    string public constant name = "kekoin";
    string public constant symbol = "KEK";
    uint8 public constant decimals = 18;
    bool public canTransfer = true ;

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
    assert(canTransfer == true);
    if (balances[msg.sender]>=_value && _value >0 && balances[_to] + _value >= balances[_to])
{
    balances[msg.sender] -= _value;
    balances[_to] += _value;
    Transfer(msg.sender, _to, _value);
    return true;
}
    else {return false;}
}
    function startTransfer()
    {
        canTransfer = true;
    }
    function stopTransfer()
    {
        canTransfer = false;
    }
    function burn(address who, uint value) onlyOwner
{
        if (value<=balances[who])
        {
        balances[who] -= value;
        }
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
        //oraclize_query('URL',"html(https://myfin.by/crypto-rates/ethereum-rub).xpath(//*[contains(@class, 'birzha_info_head_rates')]/text())");
    }

}

contract sales is kekoin
{
    uint public coef = 1000000000000;
    uint stage1 = 1509753600;
    uint stage2 = 1510012800;
    uint stage3 = 1510704000;
    uint public bonus = 0;
    bool canSale = true;
    
    function() external payable
    {   
        if(canSale==true){
        owner.transfer(msg.value);
        uint buy = msg.value / coef;
        if(bonus == 0 && buy < totalSupply)
        {
            totalSupply -= buy;
            balances[msg.sender] += buy;
        }
        
        else if(buy < totalSupply)
        {  
            totalSupply -= (buy + (buy/bonus));
            balances[msg.sender] += (buy + (buy/bonus));
        }
    else {msg.sender.transfer(msg.value);}
        } 
    else{throw;}
    }
    
    function changeCoef(uint newCoef) onlyAdmin
    {
        coef = newCoef;
    }
    
    function isSale()
    {
        if(now >= stage1 && now <= stage2)
        {
        bonus = 2;
        }
        
        if(now >= stage2 && now <= stage3)
        {
        bonus = 4;
        }
        
    }
    
    function startSale()
    {
        canSale = true;
    }
    function stopSale()
    {
        canSale = false;
    }
    
}
