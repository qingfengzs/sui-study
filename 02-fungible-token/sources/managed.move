
module fungible_tokens::managed{
    use std::option;
    use sui::coin::{Self, Coin, TreasuryCap};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};


  struct MANAGED has drop{}

  fun init(witness:MANAGED,ctx:&mut TxContext){
    let (treasury_cap,coin_metadata) =
     coin::create_currency<MANAGED>(witness,2,b"MANAGED",b"MNG",b"",option::none(),ctx);
    transfer::public_freeze_object(coin_metadata);
    transfer::public_transfer(treasury_cap,tx_context::sender(ctx));
  }

  public entry fun mint(teasury_cap:&mut TreasuryCap<MANAGED>,amount:u64,recipient: address,ctx:&mut TxContext){
    let mint_coin = coin::mint(teasury_cap,amount,ctx);
    transfer::public_transfer(mint_coin,recipient);
    // sui::coin::mint_and_transfer(teasury_cap,amount,recipient,ctx);
  }

  public entry fun burn(treasury_cap:&mut TreasuryCap<MANAGED>,coin: Coin<MANAGED>){
    sui::coin::burn(treasury_cap,coin);
  }

  
  #[test_only]
  public fun test_init(ctx:&mut TxContext){
      init(MANAGED{},ctx)
  }
}