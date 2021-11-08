pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import 'PurchasesInterface.sol';

contract PurchaseList is IPurchases{
    uint256 m_ownerPubkey;
    mapping (uint=>Purchases) m_purchases;
    uint m_count=0;

    constructor(uint256 pubkey) public {
        require(pubkey != 0, 120);
        tvm.accept();
        m_ownerPubkey = pubkey;
    }
    modifier onlyOwnerAndAccept() {
        require(msg.pubkey() == m_ownerPubkey, 101);
        tvm.accept();
        _;
    }
    //add purchase
    function createPurchases(string name,uint count)external override onlyOwnerAndAccept{
        m_count++;
        m_purchases[m_count]=Purchases(m_count,name,count,now,false,0);

    }
    //view short info about all purchases
    function infoPurchases() external override view returns (SummaryPurchases purchasesSumm){
        purchasesSumm=SummaryPurchases(0,0,0,0);

        for((,Purchases purchases): m_purchases){
                if(purchases.isBought){
                    purchasesSumm.paid+=purchases.count;
                    purchasesSumm.allPrice+=purchases.price;
                }else{
                    purchasesSumm.noPaid+=purchases.count;
                }
        }
        purchasesSumm.allCount=purchasesSumm.paid+purchasesSumm.noPaid;

    }
    //delete purchase
    function deletePurchases(uint id) external override onlyOwnerAndAccept{
            require(m_purchases.exists(id), 102);
            delete m_purchases[id];
    }
    //view all purchases
    function listPurchases() external override view returns(Purchases[] purchasesList){
            for((,Purchases purchases) : m_purchases){
                purchasesList.push(purchases);
            }
    }
    //buy purchase
    function buyById(uint id, uint price) external override onlyOwnerAndAccept{
            require(m_purchases.exists(id), 102);
            require(!m_purchases[id].isBought, 105);
            m_purchases[id].isBought=true;
            m_purchases[id].price=price;
    }

}