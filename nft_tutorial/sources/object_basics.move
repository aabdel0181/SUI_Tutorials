module nft_tutorial::object_basics {

    use sui::transfer;
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::dynamic_object_field as ofield;

    //object owned by an address
    struct ObjectA has key { id: UID }

    public entry fun create_object_owned_by_an_address(ctx: &mut TxContext) {
        transfer::transfer({
            ObjectA { id: object::new(ctx) }
        }, tx_context::sender(ctx))
    }

    //enabling storing objects owned by other objectrs 
    struct ObjectB has key, store { id: UID }

    public entry fun create_object_owned_by_an_object(parent: &mut ObjectA, ctx: &mut TxContext) {
        let child = ObjectB { id: object::new(ctx) };
        ofield::add(&mut parent.id, b"child", child);
    }

    // Shared oject : anyone can read or write to it (they must go towards consensus)
    struct ObjectC has key { id: UID }

    public entry fun create_shared_object(ctx: &mut TxContext) {
        transfer::share_object(ObjectC { id: object::new(ctx) })
    }

    // Objects that anyone can use, but nobody can change 
    struct ObjectD has key { id: UID }

    public entry fun create_immutable_object(ctx: &mut TxContext) {
        transfer::freeze_object(ObjectD { id: object::new(ctx) })
    }
}