pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;
import 'AbstractDebot.sol';

contract BuyPurchasesDebot is AbstractDebot{

string private namePurchase;
uint private idPurchase;
 function _menu() internal override{
        string sep = '----------------------------------------';
        Menu.select(
            format(
                "You have {}/{}/{}/{} (paid/not paid/total paid price/total count) purchases",
                    m_stats.paid,
                    m_stats.noPaid,
                    m_stats.allPrice,
                    m_stats.allCount
            ),
            sep,
            [
                MenuItem("Show purchases list","",tvm.functionId(listPurchases)),
                MenuItem("Delete purchases","",tvm.functionId(deletePurchases)),
                MenuItem("Buy purchases","",tvm.functionId(buyById))
            ]
        );
    }
function buyById() public {
    Terminal.input(tvm.functionId(buyById_), "Enter purchase number:", false);
}

    function buyById_(string value) public{
        (uint256 id, ) = stoi(value);
        idPurchase = id;
        Terminal.input(tvm.functionId(buyById__), "Enter purchase cost:", false);
    } 

    function buyById__(string value) public view{
       (uint256 price, ) = stoi(value);
        optional(uint256) pubkey = 0;
        IPurchases(m_address).buyById{
                abiVer: 2,
                extMsg: true,
                sign: true,
                pubkey: pubkey,
                time: uint64(now),
                expire: 0,
                callbackId: tvm.functionId(onSuccess),
                onErrorId: tvm.functionId(onError)
            }( uint(idPurchase),  uint(price));
    }

    function deletePurchases() public {
        if (m_stats.allCount > 0) {
            Terminal.input(tvm.functionId(deletePurchases_), "Enter purchase number:", false);
        } else {
            Terminal.print(0, "Sorry, you have no purchase to delete");
            _menu();
        }
    }

    function deletePurchases_(string value) public view {
        (uint256 num,) = stoi(value);
        optional(uint256) pubkey = 0;
        IPurchases(m_address).deletePurchases{
                abiVer: 2,
                extMsg: true,
                sign: true,
                pubkey: pubkey,
                time: uint64(now),
                expire: 0,
                callbackId: tvm.functionId(onSuccess),
                onErrorId: tvm.functionId(onError)
            }(uint(num));
    }

    function listPurchases() public view{
            optional(uint256) none;
            IPurchases(m_address).listPurchases{
                abiVer: 2,
                extMsg: true,
                sign: false,
                pubkey: none,
                time: uint64(now),
                expire: 0,
                callbackId: tvm.functionId(listPurchases_),
                onErrorId: 0
            }();
    }
    function listPurchases_( Purchases[] purchases ) public {
        if (purchases.length > 0 ) {
            Terminal.print(0, "Your purchases list:");
            for (uint32 i = 0; i < purchases.length; i++) {
                Purchases purchases_t = purchases[i];
                string completed;
                if (purchases_t.isBought) {
                    completed = '✓';
                } else {
                    completed = ' ';
                }
                Terminal.print(0, format("id: {} name: {} count: {} time: {} complete: {} price: {}", purchases_t.id, purchases_t.name, purchases_t.count,
                 purchases_t.timestamp,completed,purchases_t.price));
            }
        } else {
            Terminal.print(0, "Your purchases list is empty");
        }
        _menu();
    }

}