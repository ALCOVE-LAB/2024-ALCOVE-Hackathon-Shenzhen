module birds_nft::birds_nft {
    use std::option;
    use std::signer;
    use std::string;
    use std::vector;
    use std::debug::print;
    use aptos_std::string_utils;
    use aptos_framework::account;
    use aptos_framework::account::SignerCapability;
    use aptos_framework::event;
    use aptos_framework::object;
    use aptos_framework::randomness;
    use aptos_framework::object::Object;

    use aptos_token_objects::collection;
    use aptos_token_objects::royalty;
    use aptos_token_objects::token;
    use aptos_token_objects::token::Token;

    // ERROR CODE
    const ERROR_NOWNER: u64 = 1;

    const ResourceAccountSeed: vector<u8> = b"birds";

    const CollectionDescription: vector<u8> = b"birds test.";

    const CollectionName: vector<u8> = b"birds";

    const CollectionURI: vector<u8> = b"ipfs://QmWmgfYhDWjzVheQyV2TnpVXYnKR25oLWCB2i9JeBxsJbz";

    const TokenURI: vector<u8> = b"https://nftstorage.link/ipfs/bafybeidh4smpsizbccq3pbovczucxd6rhcv2d3ygm5sifqb2gqhh2bpbza";

    const TokenPrefix: vector<u8> = b"birds #";

    const InftImage:vector<u8> = b"https://bafkreic5c4t6clrpb2zetcotjfb5bbkt5vd5ijcogpdy7w3uwf7qy4lq34.ipfs.nftstorage.link/";

    struct ResourceCap has key {
        cap: SignerCapability
    }

    struct CollectionRefsStore has key {
        mutator_ref: collection::MutatorRef
    }

    struct NewBirdContent has key {
        content: string::String,
        buysigner: address,
        nftaddress: string::String,
        mintv:u8

    }


    // inftjson string----------------start---------------------------------

    struct InftJson has key,store,drop{
        size:vector<u16>,
        cell: vector<u16>,
        grid: vector<u16>,
        parts: vector<PartsObject>,
        series: vector<SeriesObject>,
        type: u8,
        image:vector<u8>
    }

    struct PartsObject has key,store,drop {
        value:vector<u16>,
        img: vector<u16>,
        position: vector<u16>,
        center: vector<u16>,
        rotation: vector<u16>,
        rarity: vector<vector<u16>>
    }

    struct SeriesObject has key,store,drop {
      name:string::String,
      desc:string::String,
      rate:string::String
    }
   // inftjson string-----------------end--------------------------------

    


    fun init_module(sender: &signer) {


        let inftJson = create_nftJson();

        print(&inftJson);

        move_to(sender, inftJson);
        let (resource_signer, resource_cap) = account::create_resource_account(
            sender,
            ResourceAccountSeed
        );

        move_to(
            &resource_signer,
            ResourceCap {
                cap: resource_cap
            }
        );

        let collection_cref = collection::create_unlimited_collection(
            &resource_signer,
            string::utf8(CollectionDescription),
            string::utf8(CollectionName),
            option::some(royalty::create(5, 100, signer::address_of(sender))),
            string::utf8(CollectionURI)
        );

        //-------------------collection MutatorRef start ---------------

        let collection_signer = object::generate_signer(&collection_cref);

        let mutator_ref = collection::generate_mutator_ref(&collection_cref);

        move_to(
            &collection_signer,
            CollectionRefsStore {
                mutator_ref
            }
        );
        //-------------------collection MutatorRef end ---------------
    }

    entry public fun mint(
        sender: &signer,
        birename: string::String,
        nftaddress: string::String

    ) acquires ResourceCap {

        let resource_cap = &borrow_global<ResourceCap>(
            account::create_resource_address(
                &@birds_nft,
                ResourceAccountSeed
            )
        ).cap;

        let resource_signer = &account::create_signer_with_capability(
            resource_cap
        );
        let url = string::utf8(TokenURI);
        
        let s = string::utf8(b"bird-");
        string::append( &mut s, string::utf8(b"xxxx"));


        let token_cref = token::create_numbered_token(
            resource_signer,
            string::utf8(CollectionName),
            string::utf8(CollectionDescription),
            string::utf8(TokenPrefix),
            string::utf8(b""),
            option::none(),
            string::utf8(TokenURI)
        );    

        // create token_mutator_ref
        let token_mutator_ref = token::generate_mutator_ref(&token_cref);
        let token_signer = object::generate_signer(&token_cref);  
        let buysigner = signer::address_of(sender);        

        move_to(
            &token_signer,
            NewBirdContent {
                content:birename,
                buysigner: buysigner,
                nftaddress: nftaddress,
                mintv:1
            }
        );     

        object::transfer(
            resource_signer,
            object::object_from_constructor_ref<Token>(&token_cref),
            signer::address_of(sender),
        )
    }    


    entry public fun sellBird(sender: &signer,bird_address:  address ) acquires ResourceCap {

      let resource_signer = getResource_signer();
      nftTransfer(sender,bird_address,signer::address_of(resource_signer));
    }  

    entry public fun buyBird(sender: &signer,bird_address:  address )  acquires ResourceCap {           

      let resource_signer = getResource_signer();    
      nftTransfer(resource_signer,bird_address,signer::address_of(sender));

    }   


    inline fun nftTransfer(owner: &signer, nft_address: address, to_address:address) {

        object::transfer(
            owner, 
            object::address_to_object<Token>(nft_address),
            to_address
        )
        
    }


    // get birds_nft resource_signer
    inline fun getResource_signer(): &signer {

      let resource_cap = &borrow_global<ResourceCap>(
            account::create_resource_address(
                &@birds_nft,
                ResourceAccountSeed
            )
        ).cap;

      let resource_signer = &account::create_signer_with_capability(
          resource_cap
      );
      resource_signer
      
    }

    // create birds_nft_json 
    inline fun create_nftJson( ) : InftJson   {

       // init inftjson  string--------------------start-----------------------
      let seriesObjects = vector::empty<SeriesObject>();    

        vector::push_back(&mut seriesObjects, SeriesObject {
          name:string::utf8(b"Blue"),
          desc:string::utf8(b"Blue style of Solana"),
          rate:string::utf8(b"0.000003814697265625")
        });

        vector::push_back(&mut seriesObjects, SeriesObject {
          name:string::utf8(b"White"),
          desc:string::utf8(b"White style of Solana"),
          rate:string::utf8(b"0.000003814697265625")
        });

        vector::push_back(&mut seriesObjects, SeriesObject {
          name:string::utf8(b"Color"),
          desc:string::utf8(b"Color style of Solana"),
          rate:string::utf8(b"0.000003814697265625")
        });

        vector::push_back(&mut seriesObjects, SeriesObject {
          name:string::utf8(b"Mix"),
          desc:string::utf8(b"All numbers"),
          rate:string::utf8(b"0.002780914306640625") 
        });


      let partsObjects = vector::empty<PartsObject>(); 

      let v = vector::empty<vector<u16>>();
      vector::push_back(&mut v, vector[2]);
      vector::push_back(&mut v, vector[1]);
      vector::push_back(&mut v, vector[7]);
      vector::push_back(&mut v, vector[1,2,6]);

      vector::push_back(&mut partsObjects, PartsObject {
          value:vector[0,2,8,0],
          img: vector[0,1,0,0],
          position: vector[20,20],
          center: vector[0,0],
          rotation: vector[0],
          rarity: v
        });

      let v1 = vector::empty<vector<u16>>();
      vector::push_back(&mut v1, vector[0]);
      vector::push_back(&mut v1, vector[5]);
      vector::push_back(&mut v1, vector[3]);
      vector::push_back(&mut v1, vector[0,5,3]);

        vector::push_back(&mut partsObjects, PartsObject {
          value:vector[4,2,8,0],
          img: vector[0,2,0,0],
          position: vector[70,20],
          center: vector[0,0],
          rotation: vector[0],
          rarity: v1
        });

        let v2 = vector::empty<vector<u16>>();
      vector::push_back(&mut v2, vector[1]);
      vector::push_back(&mut v2, vector[3]);
      vector::push_back(&mut v2, vector[7]);
      vector::push_back(&mut v2, vector[1,3,7]);

        vector::push_back(&mut partsObjects, PartsObject {
          value:vector[8,2,8,0],
          img: vector[0,3,0,0],
          position: vector[120,20],
          center: vector[0,0],
          rotation: vector[0],
          rarity: v2
        });


        let v3 = vector::empty<vector<u16>>();
      vector::push_back(&mut v3, vector[6]);
      vector::push_back(&mut v3, vector[4]);
      vector::push_back(&mut v3, vector[2]);
      vector::push_back(&mut v3, vector[2,4,6]);

        vector::push_back(&mut partsObjects, PartsObject {
          value:vector[12,2,8,0],
          img: vector[0,4,0,0],
          position: vector[170,20],
          center: vector[0,0],
          rotation: vector[0],
          rarity: v3
        });

        let v4 = vector::empty<vector<u16>>();
      vector::push_back(&mut v4, vector[1]);
      vector::push_back(&mut v4, vector[5]);
      vector::push_back(&mut v4, vector[3]);
      vector::push_back(&mut v4, vector[1,3,5]);

        vector::push_back(&mut partsObjects, PartsObject {
          value:vector[16,2,8,0],
          img: vector[0,5,0,0],
          position: vector[220,20],
          center: vector[0,0],
          rotation: vector[0],
          rarity: v4
        });

        let v5 = vector::empty<vector<u16>>();
      vector::push_back(&mut v5, vector[7]);
      vector::push_back(&mut v5, vector[5]);
      vector::push_back(&mut v5, vector[0]);
      vector::push_back(&mut v5, vector[0,5,7]);

        vector::push_back(&mut partsObjects, PartsObject {
          value:vector[20,2,8,0],
          img: vector[0,6,0,0],
          position: vector[270,20],
          center: vector[0,0],
          rotation: vector[0],
          rarity: v5
        });

        let  inftJson = InftJson{
            size: vector[360,100],
            cell: vector[50,50],
            grid: vector[8,8],
            parts: partsObjects,
            series: seriesObjects,
            type: 2,
            image:InftImage
        }; 

    // init inftjson  string--------------------end-----------------------
      inftJson   
      
    }

   
}
