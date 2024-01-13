module intro_df::car {

    use sui::transfer;
    use sui::url::{Self, Url}; 
    use sui::object{Self, ID, UID}; 
    use sui::tx_context::{Self, TxContext}; 
    use sui::dynamic_object_field as ofield; 

    //Car struct stored on-chain and with Stats attribute 'Stats'
    struct Car has key {
        id: UID, 
        stats: Stats, 
    }

    //Struct not stored on chain, but transferrable and wrappable 
    struct Stats has store {
        speed: u8, 
        acceleration: u8, 
        handling: u8, 
    }

    //Decal that is stored on chain but also possible to be owned by objects
    struct Decal has key, store {
        id: UID, 
        url: Url, 
    }


    //Now, How can we add a decal to our car when we don't even have a field for containing the decal? Think : dynamic fields 


    //Typical functions for creating a car and a decal 

    public entry fun create_car(ctx: &mut TxContext) {
        let car = Car {
            id: object::new(ctx), 
            stats: Stats {
                speed: 50, 
                acceleration: 50, 
                handling: 50, 
            }
        }; 
        transfer::transfer(car, tx_context::sender(ctx)); 
    }

    public entry fun create_decal (ctx: &mut TxContext, url_input : vector<u8>){
        let decal = Decal {
            id: object::new(ctx), 
            url: url::new_unsafe_from_bytes(url_input)
        }; 
        transfer::transfer(decal, tx_context::sender(ctx)); 

    }

    //Now we can add decal as an ofield dynamic field 

    public entry fun add_decal (car: &mut Car, decal : Decal) {
        let decal_id = object::id(&decal); //safer way of obtaininga fool-proof id of the decal 
        ofield::add(&mut car.id, decal_id, decal); //by using decal_id as the name, we prevent conflicting names from occuring 
    }

    //get URL from child directly 

    public fun get_url_via_child(decal: &Decal) : Url{
        decal.url
    } 

    //get URL from parent 
    public fun get_url_via_car(car: &Car, decal_id: ID) : Url {
        let decal_child = ofield::borrow<ID, Decal> (&car.id, decal_id); 
        get_url_via_child(decal_child)
    }

    
}