module nft_tutorial::onchain_game {

    use std::option::{Self, Option};

    use sui::transfer;
    use sui::url::{Self, Url};
    use sui::object::{Self, UID};
    use std::string::{Self, String};
    use sui::tx_context::{Self, TxContext};

    struct GameAdminCap has key { id: UID }

    struct Hero has key {
        id: UID,
        name: String,
        level: u64,
        hitpoints: u64,
        xp: u64,
        url: Url,
        sword: Option<Sword>, //can or cannot have a sword -> sword is wrapped by hero NOT Owned by hero  
    }

    //sword has key and store because it can exist as a standalone object or can be wrapped inside another object
    struct Sword has key, store {
        id: UID,
        min_level: u64,
        strength: u64
    }

    fun init(ctx: &mut TxContext) {
        transfer::transfer(
            GameAdminCap {id: object::new(ctx)}
        , tx_context::sender(ctx))
    }

    public entry fun create_hero(_: &GameAdminCap, player: address, name: vector<u8>, url: vector<u8>, ctx: &mut TxContext) {
        let hero = Hero {
            id: object::new(ctx),
            name: string::utf8(name),
            level: 1,
            hitpoints: 100,
            xp: 0,
            url: url::new_unsafe_from_bytes(url),
            sword: option::none() //they start without a sword
        };

        transfer::transfer(hero, player);
    }
    //What if we wanted to add shields or other items not currently in the struct. How? Dynamic fields! 
}