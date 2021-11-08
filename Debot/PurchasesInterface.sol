pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;
import 'PurchasesStruct.sol';

interface IPurchases {
    function createPurchases(string name,uint count)external;
    function infoPurchases() external view returns (SummaryPurchases purchasesSumm);
    function deletePurchases(uint id) external;
    function listPurchases() external view returns(Purchases[] purchasesList);
    function buyById(uint id, uint price) external;
    }
interface ITransactable {
    function sendTransaction(address dest, uint128 value, bool bounce, uint8 flags, TvmCell payload ) external;
}
abstract contract HasConstructorWithPubKey {
   constructor(uint256 pubkey) public {}
}