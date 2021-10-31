pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import 'MilitaryUnit.sol';

contract Warrior is MilitaryUnit {
    constructor(BaseStation bs) public checkOwnerAndAccept{
        bs.addUnit(this,classUnit.Warrior);
        baseAddress=address(bs);
        this.setClass(classUnit.Warrior);
        this.setDef(3);
        this.setAttck(3);
        this.setHP(20);
    }
}