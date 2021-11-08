pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;
struct Purchases{
uint id;
string name;
uint count;
uint32 timestamp;
bool isBought;
uint price;
}
struct SummaryPurchases{
    uint paid;
    uint noPaid;
    uint allPrice;
    uint allCount;
}
