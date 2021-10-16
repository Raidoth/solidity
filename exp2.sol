
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract savemultiply {
    
    uint public multipl=1;
    constructor() public {
        require(tvm.pubkey() != 0, 101);
         require(msg.pubkey() == tvm.pubkey(), 102);
         tvm.accept();
    }
    modifier checkOwnerAndAccept() {
        require(msg.pubkey()==tvm.pubkey(), 102);
        tvm.accept();
        _;
    }
    function mult(uint value)public checkOwnerAndAccept{
        require(value < 11 && value > 0, 103);
        multipl*=value;
    }

}
