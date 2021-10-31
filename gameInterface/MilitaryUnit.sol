pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import 'GameObject.sol';
import 'BaseStation.sol';

contract MilitaryUnit is GameObject {
    address baseAddress;
    BaseStation base;
    int pAtk;
    function setAttck(int _pAtk) public {
        pAtk=_pAtk;
    }
    function getAttck() public  returns(int){
        return pAtk;
    }
    function death()internal override{
       selfdestruct(enemyAddress);
       base.deleteUnit(this);
    }
    function deathBase()external{
        require(baseAddress==msg.sender,101);
        tvm.accept();
        death();
    }
    function attackEnemy(GameObject enemy,int power)public checkOwnerAndAccept{
            enemy.takeAttack(power);
    }

}