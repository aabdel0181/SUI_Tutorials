module nft_tutorial::onchain_identity {

    use std::option::{Self, Option};

    use sui::transfer;
    use sui::object::{Self, UID};
    use std::string::{Self, String};
    use sui::tx_context::{Self, TxContext};

    const EProfileMismatch: u64 = 0;

    struct AdminCap has key { id: UID }

    struct UserProfile has key {
        id: UID,
        user_address: address,
        name: String,
        bio: Option<String>,
        twitter_handle: Option<String>,
    }

    public entry fun create_profile(name: vector<u8>, ctx: &mut TxContext) {
        let user_profile = UserProfile {
            id: object::new(ctx),
            user_address: tx_context::sender(ctx),
            name: string::utf8(name),
            bio: option::none(),
            twitter_handle: option::none(),
        };

        transfer::transfer(user_profile, tx_context::sender(ctx))
    }

    public entry fun change_bio(user_profile: &mut UserProfile, new_bio: vector<u8>, ctx: &mut TxContext) {
        // Assert that only the user can change their own profile information
        assert!(tx_context::sender(ctx) == user_profile.user_address, EProfileMismatch);

        let old_bio = option::swap_or_fill(&mut user_profile.bio, string::utf8(new_bio)); //swap or fill means if we have nothing, put this one in. If we have a bio, update it 

        // We don't care about the old bio anymore, let's delete it by destructuring!
        _ = old_bio;
    }

    //We just deleted a field, but how do we delete an object? 

    public entry fun delete_profile(_: &AdminCap, user_profile: UserProfile) {

        //we must destructure the struct, setting all fields equal to _ EXPECT ID 
        let UserProfile {
            id,
            user_address: _,
            name: _,
            bio: _,
            twitter_handle: _,
        } = user_profile;

        //We cannot just destructure the struct, we must call object::delete(id) to properly delete the UID from the chain
        object::delete(id);
    }
    
}