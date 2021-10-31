pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import 'MilitaryUnit.sol';

contract Archer is MilitaryUnit {
    constructor(BaseStation bs) public checkOwnerAndAccept{
        bs.addUnit(this,classUnit.Archer);
        baseAddress=address(bs);
        this.setClass(classUnit.Archer);
        this.setDef(1);
        this.setAttck(8);
        this.setHP(10);
    }
    
}