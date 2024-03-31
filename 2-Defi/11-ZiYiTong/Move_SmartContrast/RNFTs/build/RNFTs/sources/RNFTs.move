module RNFTs::RNFTs{
    use std::option;
    use std::signer;
    use std::signer::address_of;
    use std::string;
    use std::vector;
    use aptos_std::crypto_algebra::eq;
    use aptos_std::string_utils;
    use aptos_std::table;
    use aptos_std::table::Table;
    use aptos_framework::account;
    use aptos_framework::account::SignerCapability;
    use aptos_framework::aptos_coin::AptosCoin;
    use aptos_framework::coin;
    use aptos_framework::event;
    use aptos_framework::object;
    use aptos_framework::object::{Object, object_address};
    use aptos_token_objects::collection;
    use aptos_token_objects::token;
    use aptos_token_objects::token::Token;

    const RESOURCECAPSEED : vector<u8> = b"RWAnft";
    const CollectionDescription: vector<u8> = b"RWAnft nft test";
    const CollectionName: vector<u8> = b"Rnft";
    const CollectionURI: vector<u8> = b"None";
    const TokenURI: vector<u8> = b"None";
    const TokenPrefix: vector<u8> = b"Rnft #";


    struct OwnedNFTs has key, store, copy,drop {
        nftsdata: vector<NFTWithMetadata>
    }

    struct NFTMetadata has key,store,drop,copy {
        addressStr: address,
        minted_by: address,
        description: string::String,
        shortName: string::String,
        monthly_dividend: u64,
    }

    struct NFTWithMetadata has key,drop,store,copy {
        token: Object<Token>,
        metadata: NFTMetadata,
    }

    struct ResourceCap has key {
        cap: SignerCapability
    }

    struct TokenRefsStore has key {
        burn_ref: token::BurnRef
    }

    struct Content has key {
        content: string::String
    }

    struct Orders has key, store {
        orders: Table<u64, OrderWithMeta>,
        order_counter: u64
    }

    struct OrderDataTable has key, store {
        orders: Table<u64, NFTWithMetadata>,
        order_counter: u64
    }


    #[event]
    struct OrderWithMeta has store, drop, copy {
        orderId: u64,
        seller: address,         //when order reserver ,here save creditor
        price: u64,              //as same
        token: Object<Token>,    //as same
        completed: bool,
        transtype: bool               //mark if reserve
        // Metadata: NFTWithMetadata   //only when not reserve use
    }

    #[event]
    struct MintEvent has drop, store {
        owner: address, //
        token: address,
        content: string::String,
        description: string::String,
        monthly_dividend: u64,
    }

    #[event]
    struct ModifyEvent has drop,store {
        owner: address,
        tokenId: address,
        old_content: string::String,
        new_content: string::String
    }

    #[event]
    struct BurnEvent has drop, store {
        owner: address,
        tokenId: address,
        content: string::String
    }

    #[event]
    struct TransferEvent has drop, store {
        buyer: address,
        seller: address,
        price: u64,
        tokenId: address,
        Metadata:NFTWithMetadata
    }

    #[event]
    struct ChangePrice has drop, store {
        orderId: u64,
        old_price: u64,
        new_price: u64
    }

    #[event]
    struct CancelOrder has drop, store {
        orderId: u64,
        seller: address,
        token: address
    }

    fun init_module(sender: &signer) {

        let (resource_signer, resource_cap) = account::create_resource_account(
            sender, RESOURCECAPSEED
        );

        move_to(&resource_signer, ResourceCap{ cap:resource_cap });

        collection::create_unlimited_collection(
            &resource_signer,
            string::utf8(CollectionDescription),
            string::utf8(CollectionName),
            option::none(),
            string::utf8(CollectionURI)
        );

        let orders = Orders{
            orders: table::new(),
            order_counter: 0,
        };
        let ordersmetadata = OrderDataTable{
            orders: table::new(),
            order_counter: 0,
        };

        move_to(sender, orders);
        move_to(sender, ordersmetadata);
    }

    entry public fun manulinit(sender: &signer)
    {
        let ordersmetadata = OrderDataTable{
            orders: table::new(),
            order_counter: 0,
        };
        move_to(sender, ordersmetadata);
    }

    entry public fun mint(sender: &signer, content: string::String, description:string::String,name: string::String,monthly_dividend: u64) acquires ResourceCap,OwnedNFTs {

        let resource_cap = &borrow_global<ResourceCap>(account::create_resource_address(
            &@RNFTs, RESOURCECAPSEED
        )).cap;
        let resource_signer = &account::create_signer_with_capability(resource_cap);

        let token_ref = token::create_numbered_token(
            resource_signer,
            string::utf8(CollectionName),
            string::utf8(CollectionDescription),
            string::utf8(TokenPrefix),
            string::utf8(b""),
            option::none(),
            string::utf8(TokenURI),
        );

        let url = string::utf8(TokenURI);
        let id = token::index<Token>(object::object_from_constructor_ref(&token_ref));
        string::append(&mut url, string_utils::to_string(&id));
        string::append(&mut url, string::utf8(b".png"));
        let token_mutator_ref = token::generate_mutator_ref(&token_ref);
        token::set_uri(&token_mutator_ref, url);

        let token_signer = object::generate_signer(&token_ref);

        //--------------------------
        //

        let metadata = NFTMetadata {
            addressStr: object::object_address(&object::object_from_constructor_ref<Token>(&token_ref)),
            minted_by: signer::address_of(sender),
            description:description,
            shortName:name,
            monthly_dividend,
        };

        let nft_with_metadata = NFTWithMetadata {
            token: object::object_from_constructor_ref<Token>(&token_ref),
            metadata,
        };

        event::emit(MintEvent {
            owner: signer::address_of(sender),
            token: object::object_address(&nft_with_metadata.token),
            content,
            description,
            monthly_dividend,
        });

        object::transfer(
            resource_signer,
            object::object_from_constructor_ref<Token>(&token_ref),
            signer::address_of(sender),
        );

        move_to(&token_signer, TokenRefsStore{ burn_ref: token::generate_burn_ref(&token_ref) });
        move_to(&token_signer, Content{ content });
        // move_to(sender, nft_with_metadata);

        //manage ownednft stuct

        let sender_address = signer::address_of(sender);

        if (!exists<OwnedNFTs>(sender_address)) {
            move_to(sender, OwnedNFTs { nftsdata: vector::empty(), });
        };

        let owned_nfts = borrow_global_mut<OwnedNFTs>(sender_address);
        vector::push_back(&mut owned_nfts.nftsdata, nft_with_metadata);

    }

    entry fun modify(sender: &signer, token: Object<Content>, content: string::String) acquires Content { //add fuction of changing describtion

        assert!(object::is_owner(token, signer::address_of(sender)), 1);

        let old_content = borrow_global<Content>(object::object_address(&token)).content;

        event::emit(
            ModifyEvent{
                owner: object::owner(token),
                tokenId: object::object_address(&token),
                old_content,
                new_content: content
            }
        );

        borrow_global_mut<Content>(object::object_address(&token)).content = content;

    }

    entry fun burn(sender: &signer, token: Object<Content>, tokenToken:Object<Token>) acquires TokenRefsStore, Content, OwnedNFTs, {

        assert!(object::is_owner(token, signer::address_of(sender)), 1);

        // let ownednftaddress = signer::address_of(sender);
        let TokenRefsStore{ burn_ref } = move_from<TokenRefsStore>(object::object_address(&token));
        let Content { content } = move_from<Content>(object::object_address(&token));
        // let nft_metadata_address = object::object_address(&token);

        // let _nft_with_metadata = move_from<OwnedNFTs>(signer::address_of(sender));
        ownedNftListDlt(sender,tokenToken);

        event::emit(
            BurnEvent{
                owner: signer::address_of(sender),
                tokenId: object::object_address(&token),
                content
            }
        );


        token::burn(burn_ref);
    }

    entry fun createOrder(seller: &signer, token:Object<Token>, price: u64) acquires Orders,OwnedNFTs,OrderDataTable {

        assert!( object::is_owner( token, address_of(seller) ), 2);

        let ordertb = borrow_global_mut<Orders>(@RNFTs);
        //order_counter is key
        ordertb.order_counter = ordertb.order_counter + 1;
        //create a new order
        let nft_metadata = ownedNftListDlt(seller,token);
        let new_order = OrderWithMeta{
            orderId: ordertb.order_counter,
            seller: address_of(seller),
            price: price,
            token: token,
            completed: false,
            transtype: true,
            // Metadata: nft_metadata
        };
        //upsert the new order to orders
        table::upsert(&mut ordertb.orders, ordertb.order_counter, new_order);

        let orderdatatable = borrow_global_mut<OrderDataTable>(@RNFTs);
        table::upsert(&mut orderdatatable.orders, ordertb.order_counter, nft_metadata);

        //deposite the seller's NFT to ResourceAccount
        object::transfer(seller, token, account::create_resource_address(&@RNFTs, RESOURCECAPSEED));

        event::emit(
            new_order
        );
    } //normal order

    entry fun creatReverseeOrder(creditor: &signer, token:Object<Token>) acquires Orders,OwnedNFTs,OrderDataTable {

        assert!( object::is_owner( token, address_of(creditor) ), 2);

        let orders = borrow_global_mut<Orders>(@RNFTs);
        //order_counter is key
        orders.order_counter = orders.order_counter + 1;
        //create a new order

        let owned_nftslist = borrow_global_mut<OwnedNFTs>(signer::address_of(creditor));
        let nft_find = *vector::borrow(&owned_nftslist.nftsdata, 0);

        // NFTs list
        let i=0;
        while(i < vector::length<NFTWithMetadata>(&owned_nftslist.nftsdata))
            {
                let nft_with_metadata = *vector::borrow(&owned_nftslist.nftsdata, i);
                if (nft_with_metadata.token == token) {
                    nft_find = nft_with_metadata;
                    break
                };
                i=i+1;
            };

        /*
        order in reserve type can include metadata.
        But the metadata in user account will not be deleted when submitting reserve order
        */
        let nft_metadata = ownedNftListDlt(creditor,token);

        let owned_nfts = borrow_global_mut<OwnedNFTs>(signer::address_of(creditor));
        vector::push_back(&mut owned_nfts.nftsdata, nft_metadata);

        let new_order = OrderWithMeta{
            orderId: orders.order_counter,
            seller: address_of(creditor),
            price:nft_find.metadata.monthly_dividend,
            token,
            completed: false,
            transtype: false,
            // Metadata: nft_find
        };

        //upsert the new order to orders
        table::upsert(&mut orders.orders, orders.order_counter, new_order);

        let orderdatatable = borrow_global_mut<OrderDataTable>(@RNFTs);
        table::upsert(&mut orderdatatable.orders, orders.order_counter, nft_metadata);

        //deposite the seller's NFT to ResourceAccount. Dont need it in reserve
        //object::transfer(creditor, token, account::create_resource_address(&@RNFTs, RESOURCECAPSEED));

        event::emit(
            new_order
        );

    }

    entry fun transfer(buyer: &signer, orderId: u64) acquires ResourceCap, Orders,OwnedNFTs,OrderDataTable{

        let orders = borrow_global_mut<Orders>( @RNFTs );
        let order = table::borrow(&orders.orders, orderId);
        // let nftMetadataTMP = order.Metadata;
        let transtype = order.transtype;
        let tokenOfOrder = order.token;
        let tokenOfSeller = order.seller;
        let tokenOfPrice = order.price;
//datatable manage
        let tmpDataTable = borrow_global_mut<OrderDataTable>( @RNFTs );
        let nftMetadataTMP = *table::borrow_mut(&mut tmpDataTable.orders, orderId);

        let _ = order;

        //check the order state and the balance of buyer
        assert!( order.completed==false, 2 );
        assert!(coin::balance<AptosCoin>(signer::address_of(buyer)) >= order.price, 2);

        //transfer APT from buyer to seller
        coin::transfer<AptosCoin>(buyer, order.seller, order.price);

/*
        We implement the operation of "dividends" by creating reverse order requirements for NFT mint issuers to pay us.
*/
//--------------these doesn't need in reserve order

        if(transtype) {
            //obtain the ResourceAccountSigner to trasfer NFT
            let resource_cap = &borrow_global<ResourceCap>( account::create_resource_address( &@RNFTs, RESOURCECAPSEED) ).cap;
            let resource_signer = account::create_signer_with_capability( resource_cap );

            //transfer token from seller to buyer
            object::transfer( &resource_signer, order.token, address_of(buyer)  );

            //manage nft list in each other's resources
            if(transtype) {
                if (!exists<OwnedNFTs>(signer::address_of(buyer))) {
                    move_to(buyer, OwnedNFTs { nftsdata: vector::empty(), });
                };

                let owned_nfts = borrow_global_mut<OwnedNFTs>(signer::address_of(buyer));
                vector::push_back(&mut owned_nfts.nftsdata, nftMetadataTMP);

            };
        };
//----------
        table::remove(&mut orders.orders, orderId);

        event::emit(
            TransferEvent{
                buyer: address_of(buyer),
                seller: tokenOfSeller,
                price: tokenOfPrice,
                tokenId: object::object_address(&tokenOfOrder),
                Metadata: nftMetadataTMP
            }
        );
    }

    entry fun changePrice(orderId: u64, new_price: u64) acquires Orders {

        let orders = borrow_global_mut<Orders>( @RNFTs );
        let order = table::borrow_mut(&mut orders.orders, orderId);

        let old_price = order.price;
        order.price = new_price;

        event::emit(
            ChangePrice{
                orderId,
                old_price,
                new_price
            }
        );

    }

    entry fun cancelOrder( seller: &signer, orderId: u64) acquires Orders, ResourceCap,OwnedNFTs,OrderDataTable {

        let orders = borrow_global_mut<Orders>( @RNFTs );
        let order = table::borrow(&orders.orders, orderId);
        let tokenOfOrder = order.token;

        let ordermetadata = borrow_global_mut<OrderDataTable>( @RNFTs );
        let tmpMetadata = table::borrow(&ordermetadata.orders, orderId);

        let _ = order;

        //only the creater of order can cancel the order
        assert!( order.seller==address_of(seller), 2);

        let resource_cap = &borrow_global<ResourceCap>( account::create_resource_address( &@RNFTs, RESOURCECAPSEED) ).cap;
        let resource_signer = account::create_signer_with_capability( resource_cap );

        //ResourceAccount repay NFT to seller
        object::transfer(&resource_signer, order.token, address_of(seller));
        vector::push_back(&mut borrow_global_mut<OwnedNFTs>(signer::address_of(seller)).nftsdata, *tmpMetadata);

        //remove order from orders
        table::remove( &mut orders.orders, orderId );

        event::emit(
          CancelOrder{
              orderId,
              seller: address_of(seller),
              token: object::object_address(&tokenOfOrder)
          }
        );

    }

    public fun ownedNftListDlt(sender: &signer,tokenDelete:Object<Token>) : NFTWithMetadata acquires OwnedNFTs {

        assert!(object::is_owner(tokenDelete, signer::address_of(sender)), 1);

        let owned_nftslist = borrow_global_mut<OwnedNFTs>(signer::address_of(sender));
        let new_nftsdata: vector<NFTWithMetadata> = vector::empty();
        let nft_deleted = *vector::borrow(&owned_nftslist.nftsdata, 0);

        // NFTs list
        loop{
            if (vector::is_empty<NFTWithMetadata>(&owned_nftslist.nftsdata))
                {
                    break
                };
            let nft_with_metadata = vector::pop_back(&mut owned_nftslist.nftsdata);
            if (nft_with_metadata.token == tokenDelete) {
                nft_deleted = nft_with_metadata;
                continue
            }
            else
            {
                vector::push_back(&mut new_nftsdata, nft_with_metadata);
            };
        };
        // owned_nftslist.nftsdata = new_nftsdata;
        // if(vector::is_empty<NFTWithMetadata>(&owned_nftslist.nftsdata)) {let _nft_with_metadata = move_from<OwnedNFTs>(signer::address_of(sender));};

        let _nft_with_metadata = move_from<OwnedNFTs>(signer::address_of(sender));
        move_to(sender, OwnedNFTs { nftsdata:new_nftsdata });

        return nft_deleted
    }
}