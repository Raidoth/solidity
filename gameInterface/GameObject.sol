pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import 'GameInterface.sol';

contract GameObject is GameInterface{
    enum classUnit{Base,Warrior,Archer}

int healthPoint;
int pDef;
classUnit class;
address enemyAddress;

uint16 constant SendDestroy = 160;
function getBaseEnemy() public checkOwnerAndAccept returns(address){
return enemyAddress;
}
function setClass(classUnit _class) public checkOwnerAndAccept{
    class=_class;
}
function getClass() public checkOwnerAndAccept returns(classUnit){
    return class;
}
function setHP(int hp)public virtual checkOwnerAndAccept{
healthPoint=hp;
}
function setDef(int Def)public checkOwnerAndAccept{
    pDef=Def;
}
function takeAttack(int damage) external checkOwnerAndAccept override{
    enemyAddress=address(msg.sender);
    if(damage>pDef){
    healthPoint-=damage+pDef;
    }
    if(!isLive()){
        death();
    }

}
function isLive() private view returns(bool){
        if(healthPoint<=0){
            return false;
        }else{
            return true;
        }
    }
function getAddresAttackEnemy() public returns(address){
    return enemyAddress;
 }
function death() internal virtual{
       selfdestruct(enemyAddress);
       sendAllAndDestroyAccount(enemyAddress);
    }
function sendAllAndDestroyAccount(address dest) private view checkOwnerAndAccept{
    dest.transfer(1, true, SendDestroy);
    }


function getHp()public checkOwnerAndAccept returns(int){
return healthPoint;
}
function getDef() public checkOwnerAndAccept returns(int){
    return pDef;
}

 modifier checkOwnerAndAccept() {
        require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
		_;     
    }
}