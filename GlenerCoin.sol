// SPDX-License-Identifier: GPL-3.0

// Configura a versão do compilador: 7.2
pragma solidity ^0.7.2;

interface IERC20{

    // Criando alguns métodos
    // getters

    // Suprimentos total de docs de meu contrato.
    function totalSupply() external view returns(uint256);

    // Checa o saldo de un determinado endereço.
    function balanceOf(address account) external view returns (uint256);

    // Retorna um alerta, 
    function allowance(address owner, address spender) external view returns (uint256);

    // Transferência de coins
    function transfer(address recipient, uint256 amount) external returns (bool);

    // Solicita, delega a aprovação de gastar um determinado saldo
    function approve(address spender, uint256 amount) external returns (bool);

    // Formulário de enviar e de recebimento 
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    // Eventos disparados em nossas trasferência
    event Transfer(address indexed from, address indexed to, uint256 value);


    // Eventos disparados em nossas aprovações
    event Approval(address indexed owner, address indexed spender, uint256);

}

//
contract DIOToken is IERC20{

    // Definindo o Nome de nossa moeda
    string public constant name = "Glener Token";
    string public constant symbol = "GLNR";
    uint8 public constant decimals = 18;

    mapping (address => uint256) balances;

    mapping(address => mapping(address=>uint256)) allowed;

    uint256 totalSupply_ = 10 ether;


    // Metódo Construtor onde será atribuido ao sender, o dono do contrato o endereço que publicou esse contrato na Blockchain
    constructor(){
        balances[msg.sender] = totalSupply_;
    }


    // Metódo que retorna a Suplimento total
    function totalSupply() public override view returns (uint256) {
        return totalSupply_;
    }

    // Método que retorna o balance, um determinado endereço onde o paramentro de entrada é o dono do token, 
    function balanceOf(address tokenOwner) public override view returns (uint256){
        return balances[tokenOwner];
    }

    // Função de transferência de token, 
    function transfer(address receiver, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender]-numTokens;
        balances[receiver] = balances[receiver]+numTokens;
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    // Função aprove, onde estamos delegando uma quantidade token, a um endereço onde ele vai poder gastar.
    function approve(address delegate, uint256 numTokens) public override returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }


    // Function que mostra o quanto que foi delegado, para um determinado endereço.
    function allowance(address owner, address delegate) public override view returns (uint) {
        return allowed[owner][delegate];
    }

    // Function onde temos 
    function transferFrom(address owner, address buyer, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);

        balances[owner] = balances[owner]-numTokens;
        allowed[owner][msg.sender] = allowed[owner][msg.sender]-numTokens;
        balances[buyer] = balances[buyer]+numTokens;
        emit Transfer(owner, buyer, numTokens);
        return true;
    }

}
