pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import 'GameObject.sol';

contract BaseStation is GameObject {
    int test;
    classUnit[] arrClass;
    address[] campUnit;
    constructor() public {
        setHP(100);
        setDef(1);
        setClass(classUnit.Base);
    }
   
   /* 
   mapping(address=>string)baseUnits;
    function addUnit(classUnit n) external{
        tvm.accept();
        if(n==classUnit.Archer){
            baseUnits[msg.sender]="Archer";
        }else if(n==classUnit.Warrior){
                baseUnits[msg.sender]="Warrior";
        }else{
            require(true, 105);
        }
    }

    function getUnit() public checkOwnerAndAccept returns(mapping (address=>string)){
    return baseUnits;

    }
    */
   
    function addUnit(address _addr,classUnit _class) external checkAddr(msg.sender){
            tvm.accept();
            campUnit.push(_addr);
            arrClass.push(_class);

    }
    
    modifier checkAddr(address addr) {
        for(uint i=0;i<campUnit.length;i++){
            if(campUnit[i]==addr){
                require(false,103);
            }
        }
        _;
    }

    function deleteUnit(address unitAddr)public checkOwnerAndAccept{
            if(!campUnit.empty()){
            for(uint i = 0;i<campUnit.length;i++){
                    if(campUnit[i]==unitAddr){
                        delete campUnit[i];
                        delete arrClass[i];
                        break;
                    }
                    
            }
            }
    }
    
    function getUnits() public checkOwnerAndAccept  returns(address[],classUnit[]){
            return (campUnit,arrClass);

    }
    
        function death()internal override{
                selfdestruct(getBaseEnemy());
                

        }


}