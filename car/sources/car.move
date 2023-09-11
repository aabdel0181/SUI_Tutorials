module car::car {
    //importing the object from sui library -> allows us to make and manipulate objects
    use sui::object::{Self, UID}; 
    use sui::tx_context::{Self, TxContext}; //allows us to instantiate a new object
    use sui::transfer; //allows us to transfer assets 

    // 'has key' -> will be stored on the blockchain 
    // OTHER KEYWORDS: store -> can be stored in other objects, copy -> can duplicate, drop -> can delete
    // UID field -> gives it a unique identifier 
    struct Car has key {
        id: UID, 
        speed: u8, 
        acceleration: u8, 
        handling: u8
    }
    
    // public -> anyone can call or import this function into another module 
    // friend -> only specified modules can use this function
    // entry -> can be called directly --> cannot return anything 
    // This defines the constructor of a new car, but doesn't actually create it
    fun new(speed: u8, acceleration: u8, handling: u8, ctx: &mut TxContext): Car {
        Car {
            id: object::new(ctx), 
            speed, 
            acceleration, 
            handling
        }
    }

    //This actually creates a Car and gives it to the caller
    public entry fun create(speed: u8, acceleration: u8, handling: u8, ctx: &mut TxContext){
        let car = new(speed, acceleration, handling, ctx); // create an object 
        transfer::transfer(car, tx_context::sender(ctx)) //takes in the object (car) and the recipient which is the caller in this case (tx_context::sender(ctx))
    }

    //This function allows for the transfer of the car object already created 
    public entry fun transfer(car: Car, recipient: address) {
        transfer::transfer(car, recipient); 
    }

    //simple getter function 
    //input: read-only reference to Car object
    //output: 3-tuple with stats 
    public fun get_stats(self: &Car): (u8, u8, u8) {
        (self.speed, self.handling, self.acceleration)
    }

    //Upgrades to car 

    public entry fun upgrade_speed(self: &mut Car, amount: u8) {
        self.speed = self.speed + amount; 
    }
}   