
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;


contract NFTtoken {
  
  struct TokenGames{
        string name;
        string category;
        string description;
        uint countUniqPlayerLastMonth;
        uint avgPlayerDay;
        uint countAllPlayers;
        uint costBuyGame;
        uint sellPrice;
  }
  TokenGames[] tokenArray;
mapping (uint=>uint) tokenOwner;
  function createToken(string name,string category,string description,uint countUniqPlayerLastMonth, uint avgPlayerDay, 
  uint countAllPlayers,uint costBuyGame,uint sellPrice) public checkOwnerAndAccept checkName(name){
      tokenArray.push(TokenGames(name,category,description,countUniqPlayerLastMonth,avgPlayerDay,countAllPlayers,
      costBuyGame,sellPrice));
      uint idToken=tokenArray.length-1;
      tokenOwner[idToken]=msg.pubkey();

  }

    function getTokenOwner(uint idToken) public checkOwnerAndAccept view  returns(uint) {
        if(idToken>=tokenArray.length){
            require(false,103);
        }
        return tokenOwner[idToken];
    }

    function getToken(uint idToken) public checkOwnerAndAccept view  returns(string name,string category,string description,uint countUniqPlayerLastMonth
    ,uint avgPlayerDay,uint countAllPlayers,uint costBuyGame,uint sellPrice){
        name = tokenArray[idToken].name;
        category = tokenArray[idToken].category;
        description = tokenArray[idToken].description;
        countUniqPlayerLastMonth = tokenArray[idToken].countUniqPlayerLastMonth;
        avgPlayerDay = tokenArray[idToken].avgPlayerDay;
        countAllPlayers = tokenArray[idToken].countAllPlayers;
        costBuyGame = tokenArray[idToken].costBuyGame;
        sellPrice = tokenArray[idToken].sellPrice;
    }
    function ChangeTokenOwner(uint idToken,uint NewOwner) public checkOwnerAndAccept {
         require(msg.pubkey()==getTokenOwner(idToken),104);
            tokenOwner[idToken]=NewOwner;
    }

    function NomSellToken(uint idToken,uint sellPrice)public checkOwnerAndAccept isOwnerAndAccept(idToken) {
            tokenArray[idToken].sellPrice=sellPrice;
    }
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
    modifier checkName(string name) {
        if(tokenArray.length!=0){
      for(uint i = 0;i<tokenArray.length;i++){
            require(tokenArray[i].name!=name,103);
         }
        }
        _;
    }
    modifier isOwnerAndAccept(uint idToken) {
            tvm.accept();
        require(msg.pubkey()==getTokenOwner(idToken),104);
        _;
    }

}
