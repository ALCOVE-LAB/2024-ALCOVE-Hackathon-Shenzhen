module nftc::call_fun {
    use std::string;
    use aptos_std::debug::print;
    use nftc::func::{buy_a_voucher, NFT, create_license,mint_nft, initialize};
    use nftc::func;

    entry public fun users_buy_nft(
        sender: &signer,
        collection_name: string::String,
        nft_url: string::String,
        license_name: string::String,
        nft_name: string::String,
    ) {
        let validity_period = 1000;
        let deposit_amount = 1000;
        let selling_price = 1000;
        // create_license(
        //     sender,
        // license_name,
        // nft_name,
        // validity_period,
        // deposit_amount,
        // selling_price,
        // );
        func::add_license(sender, license_name);
        func::buy_nft(sender, collection_name, nft_url,nft_name, license_name);
    }


    // delete NFt by NFT address
    entry public fun users_burn_nft(sender: &signer, nft_addr: address) {
        func::burn_nft(sender, nft_addr)
    }

    entry public fun get_all_nft_info() {
        print(&0x0)
    }

    entry public fun creator_license_nft(
        sender: &signer,
        license_name: string::String,
        nft_name: string::String,
        validity_period: u64,
        deposit_amount: u64,
        selling_price: u64,
        create_time: u64,
    ) {
        // // creator creates a license
        // func::create_license(
        //     sender,
        //     license_name,
        //     nft_name,
        //     validity_period,
        //     deposit_amount,
        //     selling_price,
        //     // create_time
        // );
        // fatch nft name
        // fatch
    }

    entry public fun creator_add_license(sender: &signer, license_name: string::String) {
        func::add_license(sender, license_name);
    }

     public fun get_nft_list(sender: &signer):vector<NFT>{
        func::get_all_nft_info(sender)
    }

    // OK
    entry public fun insert_test_nft(sender: &signer) {
        // create  license | key:NFT name , value: License struct
        // -  add: knft_vlicense: simple_map::SimpleMap<string::String, License>
        // mint nft
        // -
       let i  = 10;
        while (0 >= i) {
            buy_a_voucher(sender);
            let license_name = string::utf8(b"test");
            let nft_name = string::utf8(b"test");
            let validity_period = 1;
            let deposit_amount = 32;
            let selling_price = 60;
            // let create_time = 60;
            // create_license(sender, license_name, nft_name, validity_period, deposit_amount, selling_price);
            let collection_name = string::utf8(b"collection_name");
            let nft_url = string::utf8(b"https://www.caoyang2002.top/usr/uploads/2023/08/4079902677.jpg");
            let license = string::utf8(b"time_license");
            mint_nft(sender, collection_name, nft_url,nft_name, license);
            i = i - 1;
        };
    }


    // #[test(framework=@0x1, sender = @0x23,user = @nftc)]
    // fun test_inset_nft_query(framework: &signer, sender:&signer,user:&signer){
    //     // Start clock for testing with aptos framework
    //     timestamp::set_time_has_started_for_testing(framework);
    //     initialize(sender);
    //     insert_test_nft(sender);
    //     // let test_list= get_nft_list(sender);
    //     // print(&test_list)
    // }


    // TODO How can string be used as an argument to #[test]
    // #[test (
    // sender= @0x32,collection_name = b"collection_name",
    // nft_url = string::utf8(b"https://www.caoyang2002.top/usr/uploads/2023/08/4079902677.jpg"),
    // license_name = b"open_license",
    // nft_name = b"test_name")]
    // fun test_user_buy_nft(
    //     sender: &signer,
    //     collection_name: string::String,
    //     nft_url: string::String,
    //     license_name: string::String,
    //     nft_name: string::String,
    // ){
    //     func::buy_nft(sender, collection_name, nft_url,nft_name, license_name);
    //     func::add_license(sender, license_name);
    // }
}