pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import "Bot/Debot.sol";
import "Bot/Terminal.sol";
import "Bot/Menu.sol";
import "Bot/AddressInput.sol";
import "Bot/ConfirmInput.sol";
import "Bot/Upgradable.sol";
import "Bot/Sdk.sol";

import 'PurchasesInterface.sol';
import 'PurchasesStruct.sol';

abstract contract AbstractDebot is Debot,Upgradable {
    bytes m_icon;

    TvmCell m_purchasesStateInit; 
    address m_address; 
    SummaryPurchases m_stats;     
    uint256 m_masterPubKey;
    address m_msigAddress; 

    uint32 INITIAL_BALANCE =  200000000; 
    function _menu() virtual internal;

    function _getPurchasesSumm(uint32 answerId) public view {
        optional(uint256) none;
        IPurchases(m_address).infoPurchases{
            abiVer: 2,
            extMsg: true,
            sign: false,
            pubkey: none,
            time: uint64(now),
            expire: 0,
            callbackId: answerId,
            onErrorId: 0
        }();
    }
    function setPurchasesSumm(SummaryPurchases purchasesSumm) public {
        m_stats = purchasesSumm;
        _menu();
    }

    function setPurchasesState(TvmCell code,TvmCell data) public{
        require(msg.pubkey() == tvm.pubkey(), 101);
        tvm.accept();
        m_purchasesStateInit=tvm.buildStateInit(code,data);
    }

    function onError(uint32 sdkError, uint32 exitCode) public {
        Terminal.print(0, format("Operation failed. sdkError {}, exitCode {}", sdkError, exitCode));
        _menu();
    }

     function onSuccess() public view {
        _getPurchasesSumm(tvm.functionId(setPurchasesSumm));
    }
    
function onErrorRepeatDeploy(uint32 sdkError, uint32 exitCode) public view {
        sdkError;
        exitCode;
        deploy();
    }

function deploy() private view {
            TvmCell image = tvm.insertPubkey(m_purchasesStateInit, m_masterPubKey);
            optional(uint256) none;
            TvmCell deployMsg = tvm.buildExtMsg({
                abiVer: 2,
                dest: m_address,
                callbackId: tvm.functionId(onSuccess),
                onErrorId:  tvm.functionId(onErrorRepeatDeploy),   
                time: 0,
                expire: 0,
                sign: true,
                pubkey: none,
                stateInit: image,
                call: {HasConstructorWithPubKey, m_masterPubKey}
            });
            tvm.sendrawmsg(deployMsg, 1);
    }

function checkIfStatusIs0(int8 acc_type) public {
        if (acc_type ==  0) {
            deploy();
        } else {
            waitBeforeDeploy();
        }
    }

function waitBeforeDeploy() public  {
        Sdk.getAccountType(tvm.functionId(checkIfStatusIs0), m_address);
    }

function onErrorRepeatCredit(uint32 sdkError, uint32 exitCode) public {
        sdkError;
        exitCode;
        creditAccount(m_msigAddress);
    }

function creditAccount(address value) public {
        m_msigAddress = value;
        optional(uint256) pubkey = 0;
        TvmCell empty;
        ITransactable(m_msigAddress).sendTransaction{
            abiVer: 2,
            extMsg: true,
            sign: true,
            pubkey: pubkey,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(waitBeforeDeploy),
            onErrorId: tvm.functionId(onErrorRepeatCredit) 
        }(m_address, INITIAL_BALANCE, false, 3, empty);
    }

 function checkStatus(int8 acc_type) public {
        if (acc_type == 1) { 
           _getPurchasesSumm(tvm.functionId(setPurchasesSumm));

        } else if (acc_type == -1)  { 
            Terminal.print(0, "You don't have a purchases list yet, so a new contract with an initial balance of 0.2 tokens will be deployed");
            AddressInput.get(tvm.functionId(creditAccount),"Select a wallet for payment. We will ask you to sign two transactions");

        } else  if (acc_type == 0) { 
            Terminal.print(0, format(
                "Deploying new contract. If an error occurs, check if your purchases contract has enough tokens on its balance"
            ));
            deploy();

        } else if (acc_type == 2) {  
            Terminal.print(0, format("Can not continue: account {} is frozen", m_address));
        }
    }

        function savePublicKey(string value) public {
        (uint res, bool status) = stoi("0x"+value);
        if (status) {
            m_masterPubKey = res;

            Terminal.print(0, "Checking purchases list...");
            TvmCell deployState = tvm.insertPubkey(m_purchasesStateInit, m_masterPubKey);
            m_address = address.makeAddrStd(0, tvm.hash(deployState));
            Terminal.print(0, format( "Info: your purchases list located: {} address", m_address));
            Sdk.getAccountType(tvm.functionId(checkStatus), m_address);

        } else {
            Terminal.input(tvm.functionId(savePublicKey),"Wrong public key. Try again!\nPlease enter your public key",false);
        }
    }

    function start() public override {
        Terminal.input(tvm.functionId(savePublicKey),"Please enter your public key",false);
    }

    function getDebotInfo() public functionID(0xDEB) override view returns(
        string name, string version, string publisher, string key, string author,
        address support, string hello, string language, string dabi, bytes icon
    ) {
        name = "Purchases List DeBot";
        version = "0.1.1";
        publisher = "Raidoth";
        key = "Purchases list manager";
        author = "Raidoth";
        support = address.makeAddrStd(0, 0x66e01d6df5a8d7677d9ab2daf7f258f1e2a7fe73da5320300395f99e01dc3b5f);
        hello = "Hi, i'm a Purchases List DeBot.";
        language = "en";
        dabi = m_debotAbi.get();
        icon = m_icon;
    }

    function onCodeUpgrade() internal override {
        tvm.resetStorage();
    }
    function getRequiredInterfaces() public view override returns (uint256[] interfaces) {
        return [ Terminal.ID, Menu.ID, AddressInput.ID, ConfirmInput.ID ];
    }

}
