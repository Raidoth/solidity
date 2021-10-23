pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;


contract Wallet {
uint16 constant CommissionOUT = 0;
uint16 constant CommissionIN = 1;
uint16 constant SendDestroy = 160;
    constructor() public {
     
        require(tvm.pubkey() != 0, 101);
    
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    modifier checkOwnerAndAccept {
       
        require(msg.pubkey() == tvm.pubkey(), 100);

		tvm.accept();
		_;
	}
 
    function sendTransactionWithoutCommission(address dest,uint128 value,bool bounce) public view checkOwnerAndAccept{
    dest.transfer(value, bounce, CommissionOUT);
    }
    function sendTransactionWithCommission(address dest,uint128 value,bool bounce) public view checkOwnerAndAccept{
    dest.transfer(value, bounce, CommissionIN);
    }
     function sendAll_DestroyAccount(address dest) public view checkOwnerAndAccept{
    dest.transfer(1, true, SendDestroy);
    }
}