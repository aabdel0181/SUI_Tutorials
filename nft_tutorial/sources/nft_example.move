module nft_tutorial::nft_example {

    use sui::url::{Self, Url};
    use std::string::{Self, String};
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    struct NFT has key, store {
        id: UID,
        name: String,
        description: String,
        url: Url,
        // ... Additional attributes for various use cases (i.e. game, social profile, etc.)
    }

    public entry fun mint_to_sender(
        name: vector<u8>,
        description: vector<u8>,
        url: vector<u8>,
        ctx: &mut TxContext
    ) {
        let sender = tx_context::sender(ctx);
        let nft = NFT {
            id: object::new(ctx),
            name: string::utf8(name),
            description: string::utf8(description),
            url: url::new_unsafe_from_bytes(url)
        };
        transfer::transfer(nft, sender);
    }

    //NOTE: we use string::utf8(bytes) which takes in a vector of u8s and outputs a strin g
    // new_unsafe_from_bytes converts bytes into a url format, without verifying validity
}