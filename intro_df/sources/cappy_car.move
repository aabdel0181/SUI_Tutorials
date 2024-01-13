module intro_df::cappy_car {
    use capy::capy::{Self, Capy}; 
    use intro_df::car::Car; 

    //Adding a dof 'Car' as a child of the parent object 'Capy' 
    public entry fun ride_car (capy: &Capy, car: Car) {
        capy::add_item(capy, car); 
    }

    //we can only do this because capy module exposes add_item function 
    
}