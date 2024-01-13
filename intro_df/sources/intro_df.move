module intro_df::intro_df {
    use sui::transfer;
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::dynamic_field as field; 
    use sui::dynamic_object_field as ofield; 

    //Parent Object struct 
    struct Parent has key {
        id: UID, 
    }

    //Child dynamic field containing a counter 
    struct DFChild has store {
        count: u64, 
    }

    //Child dynamic OBJECT field with a different counter 
    struct DOFChild has key, store {
        id: UID, 
        count: u64, 
    }

    //add a df object to parent 
    public fun add_dfchild(parent: &mut Parent, child: DFChild, name: vector<u8>) {
        field::add(&mut parent.id, name, child); 
    }

    //add a dof 
    public entry fun add_dofchild(parent: &mut Parent, child: DOFChild, name: vector<u8>)
    {
        ofield::add(&mut parent.id, name, child); 
    }

    //mutate a dof child directly 
    public entry fun mutate_dofchild(child: &mut DOFChild) {
        child.count = child.count +1; 
    }

    //mutate a df child directly 
    public fun mutate_dfchild(child : &mut DFChild)
    {
        child.count = child.count + 1; 
    }

    //Why can we have entry for dof but not df? Because in order to modify something from user pov, object must be accessible on the blockchain. However, DF's are not objects and are therefore not accessible directly through an entry function 

    //mutate a dof child through parent 
    public entry fun mutate_dofchild_via_parent(parent: &mut Parent, child_name: vector<u8>)
    {
        //here we first grab the child using the ofield borrow function, passing in the child name to obtain 
        let child = ofield::borrow_mut<vector<u8>, DOFChild>(&mut parent.id, child_name); 
        //then we call our function 
        mutate_dofchild(child); 
    }

    //mutate a df child through parent
    public entry fun mutate_dfchild_via_paren(parent: &mut Parent, child_name: vector<u8>)
    {   
        //same thing where we grab the child object from the parent.id using the name 
        let child = field::borrow_mut<vector<u8>, DFChild>(&mut parent.id, child_name); 
        child.count = child.count +1; 
    }
}