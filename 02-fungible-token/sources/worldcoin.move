
module fungible_tokens::worldcoin{
    use std::option;
    use sui::coin::{Self, Coin, TreasuryCap};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};


  struct WORLDCOIN has drop{}

  fun init(witness:WORLDCOIN,ctx:&mut TxContext){
    let (treasury_cap,coin_metadata) =
     coin::create_currency<WORLDCOIN>(witness,2,b"WORLDCOIN",b"WORLDCOIN",b"",option::none(),ctx);
    transfer::public_freeze_object(coin_metadata);
    transfer::public_transfer(treasury_cap,tx_context::sender(ctx));
  }

  public entry fun mint(teasury_cap:&mut TreasuryCap<WORLDCOIN>,amount:u64,recipient: address,ctx:&mut TxContext){
    let mint_coin = coin::mint(teasury_cap,amount,ctx);
    transfer::public_transfer(mint_coin,recipient);
    // sui::coin::mint_and_transfer(teasury_cap,amount,recipient,ctx);
  }

  public entry fun burn(treasury_cap:&mut TreasuryCap<WORLDCOIN>,coin: Coin<WORLDCOIN>){
    sui::coin::burn(treasury_cap,coin);
  }

  
  #[test_only]
  public fun test_init(ctx:&mut TxContext){
      init(WORLDCOIN{},ctx)
  }
}