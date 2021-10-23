
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract queue_shop {
    
   string[] public queue_shop;
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
    function set_person_queue(string person)public checkOwnerAndAccept{
            queue_shop.push(person);
    }
    
    function get_person_queue()public checkOwnerAndAccept{
        require(!queue_shop.empty(),103);
        if(queue_shop.length==1){
            queue_shop.pop();
            return;
        }
      for(uint i = 0;i+1<queue_shop.length;i++){
          queue_shop[i]=queue_shop[i+1];
          queue_shop.pop();
      }
    }

}
