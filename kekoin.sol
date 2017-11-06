pragma solidity ^0.4.0;
//import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

// библиотека для математических вычислений 
library SafeMath {
    
  function mul(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }
 
  function div(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a / b;
    return c;
  }
 
  function sub(uint256 a, uint256 b) internal constant returns (uint256) {
    assert(b <= a);
    return a - b;
  }
 
  function add(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
  
}
 
// Контракт модификаторов и функций доступа
contract permissions
{
    address owner = msg.sender;
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
    function addAdmin(address _admin)
    {
        admin = _admin;
    }
}

// Главный контракт
contract kekoin is permissions
{
    using SafeMath for uint256;
 
    string public constant name = "kekoin";
    string public constant symbol = "KEK";
    uint8 public constant decimals = 0;
    bool public canTransfer = true ;

    uint internal totalSupply = 13372280;

    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
    

    function balanceOf(address _owner) constant returns (uint256 balance)
    {
        return balances[_owner];
    }

    function transfer(address _to, uint256 _value) returns (bool success)
    {
        assert(canTransfer == true);
    if (balances[msg.sender]>=_value && _value >0 && balances[_to].add(_value) >= balances[_to])
    {
        balances[msg.sender]= balances[msg.sender].sub(_value);
        balances[_to]= balances[_to].add(_value);
        Transfer(msg.sender, _to, _value);
        return true;
    }
    else {return false;}
    }
    function startTransfer() onlyOwner
    {
        canTransfer = true;
    }
    function stopTransfer() onlyOwner
    {
        canTransfer = false;
    }
    function burn(address who, uint value) onlyAdmin
    {
        if (value<=balances[who])
        {
            balances[who] = balances[who].sub(value);
        }
        else{}
    }

    function transferFrom(address _from, address _to, uint _value) returns (bool success)
    {
    if( allowed[_from][msg.sender] >= _value &&
    balances[_from] >= _value
    && balances[_to].add(_value) >= balances[_to]) 
    {
        allowed[_from][msg.sender]=  allowed[_from][msg.sender].sub(_value);
        balances[_from]= balances[_from].sub(_value);
        balances[_to]= balances[_to].add(_value);
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

    function mint(address _to, uint256 _value) onlyOwner
    {
        assert(totalSupply.add(_value) >= totalSupply && balances[_to].add(_value) >= balances[_to]);
        balances[_to]= balances[_to].add(_value);
        totalSupply= totalSupply.add(_value);
    }
    function getPrice()
    {
        //oraclize_query('URL',"html(https://myfin.by/crypto-rates/ethereum-rub).xpath(//*[contains(@class, 'birzha_info_head_rates')]/text())");
    }

}
// Контракт для реализации продажи токенов
contract sales is kekoin
{
    uint coef = 1000000000000;
    uint stage1 = 1509753600;
    uint stage2 = 1510012800;
    uint stage3 = 1510704000;
    uint public bonus = 0;
    bool public canSale = true;
    uint public coinCount = totalSupply;
    
    function() external payable
    {   
        if(coinCount>0){
        if(canSale==true){
        owner.transfer(msg.value);
        uint buy = msg.value.div(coef);
        if(bonus == 0 && buy < totalSupply && buy<coinCount)
        {
            totalSupply= totalSupply.sub(buy);
            coinCount = coinCount.sub(buy);
            balances[msg.sender]= balances[msg.sender].add(buy);
        }
        
        else if(buy < totalSupply && buy< coinCount)
        {  
            totalSupply= totalSupply.sub((buy.add(buy.div(bonus))));
            coinCount= coinCount.sub((buy.add(buy.div(bonus))));
            balances[msg.sender]= balances[msg.sender].add((buy.add(buy.div(bonus))));
        }
    else {msg.sender.transfer(msg.value);}
        } 
    else{}
    }}
    
    function changeCoef(uint newCoef) onlyAdmin
    {
        coef = newCoef;
    }
    
    function isSale(uint _stage1, uint bonus1, uint _stage2, uint bonus2, uint _stage3) onlyAdmin
    {
        stage1 = _stage1;
        stage2 = _stage2;
        stage3 = _stage3;
        if(now >= stage1 && now <= stage2)
    {
        bonus = bonus1;
    }
        
        if(now >= stage2 && now <= stage3)
    {
        bonus = bonus2;
    }
        
    }
    
    function chngCoinNumber(uint num, uint _bonus) onlyAdmin
    {
        coinCount = num;
        bonus = _bonus;
    }
    
    function startSale() onlyOwner
    {
        canSale = true;
    }
    function stopSale() onlyOwner
    {
        canSale = false;
    }
    
}
