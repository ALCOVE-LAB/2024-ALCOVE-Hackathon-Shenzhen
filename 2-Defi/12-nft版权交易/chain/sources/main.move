module nftc::func {
    use std::option;
    use std::signer;
    use std::signer::address_of;
    use std::string;
    use aptos_std::debug::print;
    use aptos_std::simple_map;
    use aptos_std::smart_vector;
    use aptos_std::smart_vector::SmartVector;
    use aptos_std::string_utils;
    use aptos_framework::account;
    use aptos_framework::account::SignerCapability;
    use aptos_framework::aptos_coin::AptosCoin;
    use aptos_framework::coin;
    use aptos_framework::coin::Coin;
    use aptos_framework::event;
    use aptos_framework::object;
    use aptos_framework::object::ObjectCore;
    use aptos_framework::timestamp;
    use aptos_token_objects::collection;
    use aptos_token_objects::collection::create_collection_address;
    use aptos_token_objects::royalty;
    use aptos_token_objects::token;
    use aptos_token_objects::token::Token;
    #[test_only]
    use aptos_framework::aptos_coin;

    friend nftc::call_fun;

    // price
    const DEPOSIT_AMOUNT: u64 = 40_000;

    const SELLING_PRICE: u64 = 10_000;
    /// Error no voucher
    const ERROR_NO_VOUCHER: u64 = 1;
    // Error expired
    const ERROR_EXPIRED: u64 = 2;
    /// Error no owner
    const ERROR_NOWNER: u64 = 3;
    /// Not found nft address
    const NOT_FOUND_NFT_ADDRESS: u64 = 4;
    /// Not found nft license
    const NOT_FOUND_NFT_LICENSE: u64 = 5;
    /// No object
    const E_NO_OBJECT: u64 =6;

    // about collection
    const ResourceAccountSeed: vector<u8> = b"test";
    const CollectionName: vector<u8> = b"collection name";
    const CollectionDescription: vector<u8> = b"collction description";
    const CollectionURI: vector<u8> = b"https://www.caoyang2002.top/usr/uploads/2023/08/4079902677.jpg";

    struct ResourceCap has key {
        cap: SignerCapability
    }

    struct CollectionRefsStore has key {
        mutator_ref: collection::MutatorRef
    }

    //
    struct License has key, store, copy {
        license_name: string::String,
        nft_name: string::String,
        user_addr: address,
        deposit_amount: u64,
        selling_price: u64,
        create_time: u64,
        validity_period: u64,
        is_nft_expired: bool
    }

    // NFT and NFT info
    struct NFT has key, store, copy, drop {
        name: string::String,
        url: string::String,
    }

    struct NftList has key, store {
        nft_list: smart_vector::SmartVector<NFT>,
    }

    // key: user address,  value:License name
    struct User_License_map has key, store {
        addr_license: simple_map::SimpleMap<address, SmartVector<string::String>>,
    }

    // key:NFT name , value: License name
    struct NftName_License_map has key, store {
        knft_vlicense: simple_map::SimpleMap<string::String, License> // user address
    }

    struct TokenRefsStore has key {
        burn_ref: token::BurnRef,
    }

    struct Voucher has key {
        tickets: SmartVector<address>,
        coins: Coin<AptosCoin>,
        is_closed: bool,
    }

    #[event]
    struct MintEvent has drop, store {
        owner: address,
        token_id: address,
    }

    #[event]
    struct BurnEvent has drop, store {
        owner: address,
        token_id: address,
    }

    // This is not called in tests
    fun init_module(sender: &signer) {
        initialize(sender);
    }

    // Must call this in tests
    public(friend) fun initialize(sender: &signer) {
        let (resource_signer, resource_cap) = account::create_resource_account(
            sender,
            ResourceAccountSeed
        );

        let collection_cref = collection::create_unlimited_collection(
            &resource_signer,
            string::utf8(CollectionDescription),
            string::utf8(CollectionName),
            option::some(royalty::create(5, 100, signer::address_of(sender))),
            string::utf8(CollectionURI)
        );
        let collection_signer = object::generate_signer(&collection_cref);
        let mutator_ref = collection::generate_mutator_ref(&collection_cref);
        move_to(
            &collection_signer,
            CollectionRefsStore {
                mutator_ref
            }
        );
        move_to(
            sender,
            License {
                license_name: string::utf8(b""),
                nft_name: string::utf8(b""),
                user_addr: address_of(sender),
                deposit_amount: 10_000,
                selling_price: 1_000,
                create_time: timestamp::now_microseconds(),
                validity_period: 100,
                is_nft_expired: false,
            }
        );
        move_to(
            &resource_signer,
            ResourceCap {
                cap: resource_cap
            }
        );
        move_to(
            sender,
            Voucher {
                tickets: smart_vector::empty(),
                coins: coin::zero(),
                is_closed: false,
            }
        );
        move_to(
            sender,
            NFT {
                name: string::utf8(b""),
                url:string::utf8(b"")
            }
        );
        move_to(
            // &resource_signer,
            sender,
            NftList {
                nft_list: smart_vector::empty()
            }
        );

        move_to(
            sender,
            NftName_License_map{
                knft_vlicense: simple_map::new()
            }
        )
    }


    //
    entry public fun create_license(
        sender:&signer,
        license_name: string::String,
        nft_name: string::String,
        validity_period: u64,
        deposit_amount: u64,
        selling_price: u64,
        create_time: u64,
    ) acquires NftName_License_map {
        let license = License {
            license_name, nft_name,
            user_addr: address_of(sender),
            deposit_amount,
            selling_price,
            create_time: timestamp::now_microseconds(),
            validity_period,
            is_nft_expired: false,
        };
        // Put license in caller's account
        move_to(sender,license);
        print(&string::utf8(b"Time when the license is created"));
        print(&timestamp::now_microseconds());
        assert!(exists<NftName_License_map>(@nftc), E_NO_LICENSE_MAP);
        let nftname_license_map = borrow_global_mut<NftName_License_map>(@nftc);
        let nft_license_mut = &mut nftname_license_map.knft_vlicense;
        simple_map::add(nft_license_mut, nft_name, license)
    }

    entry public(friend) fun add_license(sender: &signer, license_name: string::String) acquires User_License_map {
        let user_license_map = borrow_global_mut<User_License_map>(@nftc);
        let user_license_mut = &mut user_license_map.addr_license;
        let license_vector = smart_vector::new<string::String>();
        smart_vector::push_back(&mut license_vector, license_name);
        simple_map::add(user_license_mut, signer::address_of(sender), license_vector);
    }

    public(friend) fun get_all_nft_info(sender: &signer): vector<NFT> acquires NftList {
        let address = signer::address_of(sender);
        assert!(exists<NftList>(address), 1);
        let nft = borrow_global<NftList>(address);
        smart_vector::to_vector(&nft.nft_list)
    }

    entry public fun mint_nft(
        sender: &signer,
        collection_name: string::String,
        nft_url: string::String,
        nft_name:string::String,
        license: string::String) acquires Voucher, ResourceCap, NftList, NFT {
        let voucher = borrow_global_mut<Voucher>(@nftc);
        // has voucher ?
        assert!(!smart_vector::is_empty(&voucher.tickets), ERROR_NO_VOUCHER);
        let resource_address = account::create_resource_address(&@nftc, ResourceAccountSeed);
        let resource_cap = &borrow_global<ResourceCap>(resource_address).cap;
        let resource_signer = &account::create_signer_with_capability(resource_cap);
        let url = nft_url;

        // create collection
        let collection_cref = collection::create_unlimited_collection(
            resource_signer,
            license,
            collection_name,
            option::some(royalty::create(5, 100, signer::address_of(sender))),
            nft_url
        );
        //
        let collection_signer = object::generate_signer(&collection_cref);
        let mutator_ref = collection::generate_mutator_ref(&collection_cref);
        move_to(
            &collection_signer,
            CollectionRefsStore {
                mutator_ref
            }
        );
        assert!(object::object_exists<ObjectCore>(collection::create_collection_address(&resource_address, &collection_name)), E_NO_OBJECT);

        let token_cref = token::create_numbered_token(
            resource_signer,
            collection_name,
            license,
            string::utf8(b"prefix"),
            string::utf8(b"suffix"),
            option::none(),
            string::utf8(b""),
        );
        let token_signer = object::generate_signer(&token_cref);
        let token_mutator_ref = token::generate_mutator_ref(&token_cref);
        token::set_uri(&token_mutator_ref, url);
        let token_burn_ref = token::generate_burn_ref(&token_cref);
        // --------------
        // set nft content
        let nft_info = borrow_global_mut<NFT>(signer::address_of(sender));
        nft_info.name = nft_name;
        nft_info.url = nft_url;
        let nft_list = borrow_global_mut<NftList>(signer::address_of(sender));
        // nft_list.nft_list = nft_info;
        smart_vector::push_back(&mut nft_list.nft_list, *nft_info);
        // let nft_vector = smart_vector::new<NFT>();
        // smart_vector::push_back(&mut nft_vector, *nft_info);

        // -----------------
        move_to(
            &token_signer,
            TokenRefsStore {
                burn_ref: token_burn_ref,
            }
        );

        event::emit(
            MintEvent {
                owner: signer::address_of(sender),
                token_id: object::address_from_constructor_ref(&token_cref),
            }
        );

        object::transfer(
            resource_signer,
            object::object_from_constructor_ref<Token>(&token_cref),
            signer::address_of(sender),
        )
    }

    // delete NFT by token address
    entry public(friend) fun burn_nft(
        sender: &signer,
        token_addr: address,
    ) acquires TokenRefsStore, License {
        refresh(sender); // update license time
        let TokenRefsStore {
            burn_ref,
        } = move_from<TokenRefsStore>(signer::address_of(sender));

        event::emit(
            BurnEvent {
                owner: signer::address_of(sender),
                token_id: token_addr,
            }
        );
        token::burn(burn_ref);
    }

    // --------------------
    // public(friend) fun query_nft_deposit_amount(
    //     sender: &signer,
    //     // license: License,
    //     nft_name: string::String
    // ): u64 acquires NftName_License_map {
    //     let nftname_license_map = borrow_global_mut<NftName_License_map>(signer::address_of(sender));
    //     // let mut_map = &license_nft_map.license_nft_id;
    //     let user_addr_mut_map = &mut nftname_license_map.knft_vlicense;
    //     let exist = simple_map::contains_key(user_addr_mut_map, &nft_name);
    //     assert!(exist, NOT_FOUND_NFT_ADDRESS);
    //     let value_map = simple_map::borrow_mut(user_addr_mut_map, &nft_name);
    //     value_map.
    // }


    entry public(friend) fun buy_nft(
        sender: &signer,
        collection_name: string::String,
        nft_url: string::String,
        nft_name: string::String,
        token_desc_as_license: string::String
    ) acquires License, Voucher, ResourceCap, NftList, NFT {
        refresh(sender); // fatch now info
        mint_nft(sender, collection_name, nft_url, nft_name,token_desc_as_license);
    }

    /// No license
    const E_NO_LICENSE: u64 = 3;
    /// No license map
    const E_NO_LICENSE_MAP: u64 = 4;


    // Refresh the user's NFT protocol to check if it has expired
    entry public fun refresh(sender: &signer) acquires License {
        let sender_address = signer::address_of(sender);
        // assert!(exists<License>(sender_address), E_NO_LICENSE);
        let license = borrow_global_mut<License>(sender_address);
        // print(&license.crate_time);
        // print(&timestamp::now_seconds());
        let duration_of_use = timestamp::now_microseconds() - license.create_time;
        print(&string::utf8(b"current time"));
        print(&string_utils::to_string( &timestamp::now_microseconds()));
        print(&string::utf8(b"time --"));
        print(&license.validity_period);
        print(&string::utf8(b"time --"));
        if (duration_of_use >= license.validity_period) {
            print(&string::utf8(b"unusable"));
            license.is_nft_expired = !license.is_nft_expired;
            // assert!(license.is_nft_expired, ERROR_EXPIRED);
        };
        print(&string::utf8(b"usable"));
    }


    entry public(friend) fun buy_a_voucher(sender: &signer) acquires Voucher, License {
        refresh(sender);
        let voucher = borrow_global_mut<Voucher>(@nftc);
        let coins = coin::withdraw<AptosCoin>(sender, DEPOSIT_AMOUNT + SELLING_PRICE);
        coin::merge(&mut voucher.coins, coins);
        smart_vector::push_back(&mut voucher.tickets, signer::address_of(sender))
    }


    // --------------------------------------------------
    // #[test(aptos_framework = @0x1, sender = @nftc)]
    // public fun test_mint(aptos_framework: &signer, sender: &signer) acquires Voucher, License, ResourceCap, NftList, NFT, NftName_License_map {
    //     timestamp::set_time_has_started_for_testing(aptos_framework);
    //     account::create_account_for_test(signer::address_of(sender));
    //     coin::register<AptosCoin>(sender);
    //     let sender_addr = signer::address_of(sender);
    //     let (burn_cap, mint_cap) = aptos_coin::initialize_for_test(aptos_framework);
    //     coin::deposit(sender_addr, coin::mint(1000000, &mint_cap));
    //
    //     // ------------------------
    //     init_module(sender);
    //     timestamp::fast_forward_seconds(5);
    //     // print(&timestamp::now_microseconds());
    //     // print(&200);
    //     print(&coin::balance<AptosCoin>(signer::address_of(sender)));
    //
    //     buy_a_voucher(sender);
    //     let license_name= string::utf8(b"license_name");
    //     let nft_name = string::utf8(b"nft_name");
    //     let  validity_period = 60;
    //     let deposit_amount = 1000;
    //     let selling_price = 10000;
    //     // create_license(
    //     //     sender,
    //     //     license_name,
    //     //     nft_name,
    //     //     validity_period,
    //     //     deposit_amount,
    //     //     selling_price
    //     // );
    //
    //     let nft_url = string::utf8(b"https://www.caoyang2002.top/usr/uploads/2023/08/4079902677.jpg");
    //     let nft_name = string::utf8(b"nft_name");
    //     let collection_name = string::utf8(b"collection name");
    //     let token_desc_as_license = string::utf8(b"open license");
    //     refresh(sender);
    //     // print(&nft_content.url);
    //     mint_nft(sender, collection_name, nft_url, nft_name,token_desc_as_license);
    //     let nft_content = borrow_global<NFT>(signer::address_of(sender));
    //     print(&nft_content.name);
    //     print(&nft_content.url);
    //     print(&200);
    //
    //     // ----------------------
    //     coin::destroy_burn_cap(burn_cap);
    //     coin::destroy_mint_cap(mint_cap);
    // }
}