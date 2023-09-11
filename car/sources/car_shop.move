module car::car_shop {

    use sui::transfer; 
    use sui::sui::SUI; 
    use sui::coin::{Self,Coin}; 
    use sui::object::{Self, UID}; 
    use sui::balance::{Self, Balance}; 
    use sui::tx_context::{Self, TxContext}; 

      //Creating a constant 
     const EInsufficientBalance: u64 = 0; 

      //making our car object
     struct Car has key {
        id: UID, 
        speed: u8, 
        acceleration: u8, 
        handling: u8 
     }

      // making our car shop object 
      struct CarShop has key {
         id: UID, 
         price: u64, 
         balance: Balance<SUI>
      }

      // making our shop owner admin capability
      struct ShopOwnerCap has key {
         id: UID
      }

      fun init(ctx: &mut TxContext) { 
         // here we create & transfer a new shop owner cap to the person that calls this function 
         transfer::transfer(ShopOwnerCap {id: object::new(ctx)}, tx_context::sender(ctx)); 

         // making a carShop -> same address as the admin -> share the carshop with everyone 
         transfer::share_object(CarShop {id: object::new(ctx), price: 100, balance: balance::zero()})
      }

      public entry fun buy_car(shop: &mut CarShop, payment: &mut Coin<SUI>, ctx: &mut TxContext) {
         //checks to see if payment account is >= cost of a car, if not then it rasises an error
         assert!(coin::value( ) >= shop.price, EInsufficientBalance); 

         //get the muteable balance of Coin<SUI> object
         let coin_balance = coin::balance_mut(payment); 

         //gets the paid amount from the purchasers balance 
         let paid = balance::split(coin_balance, shop.price); 

         //adds the paid amount onto the shop's total balance -> gives the money to the shop 
         balance::join(&mut shop.balance, paid); 

         //gives the car to the person who purchased it 
         transfer::transfer(Car {
            id: object::new(ctx), 
            speed: 50, 
            acceleration: 50, 
            handling: 50
         }, tx_context::sender(ctx))
      }

      public entry fun collect_profits(_: &ShopOwnerCap, shop: &mut CarShop, ctx: &mut TxContext)
   //going into sui standard library 

   //A coin of type 'T' is worth 'value'. Transferrable (key) and storable (store)
   struct Coin<phantom T> has key, store {
      id: UID, 
      balance: Balance<T>
   }

   // Public getter for the coin's value 


}