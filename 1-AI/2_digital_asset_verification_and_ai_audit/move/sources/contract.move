module contract::ContractDatabase {

    const CONTRACT:address = @0x42;
    use std::vector;
    use std::string::String;
    use std::string;

    use std::debug::print;

    //use std::signer; //signer
    use aptos_framework::account;
    use aptos_framework::object;
    use aptos_framework::object::Object;

    use aptos_std::table::{Self, Table}; 
    use aptos_framework::event;

    use std::signer;
    

    // Errors Checking
    const NOT_INITIALIZED: u64 = 1;
    const NOT_EXIST: u64 = 2;
    const ETASK_IS_COMPLETED: u64 = 3;


    struct Contracts has store, key
    {
        contract_saved: Table<u64, Contract>,
        contract_counter:u64
    }

    #[event]
    struct Contract has store, key, drop , copy
    {
        contract_id: u64,
        creator: address,
        contract_signer: address,
        content: String, //hash data for digital contract
        sign: bool,
    }

    public entry fun create_contract(account: &signer) {
        let new_contract = Contracts {
            contract_saved: table::new(),
            contract_counter: 0
        };
        // move the Contracts resource under the signer account
        move_to(account, new_contract);
    }

    public entry fun add_contract(account: &signer, account2: address, content:String) acquires Contracts {
        // gets the signer address
        let creator_address = signer::address_of(account);
        let signer_address = account2;
        // assert signer has created a list
        assert!(exists<Contracts>(creator_address), NOT_INITIALIZED);
        // gets the Contracts resource
        let contracts_list = borrow_global_mut<Contracts>(creator_address);
        // increment contract counter
        let counter = contracts_list.contract_counter + 1;
        // creates a new Contract
        let newContract = Contract {
        contract_id: counter,
        creator: creator_address,
        contract_signer: signer_address,
        content: content,
        sign: false,
        };
        // adds the new contract into the contract database
        table::upsert(&mut contracts_list.contract_saved, counter, newContract);
        // sets the contract counter to be the incremented counter
        contracts_list.contract_counter = counter;
        // a new contract created event
        event::emit(newContract);
    }

    public entry fun update_contract(account1: &signer, contract_id:u64) acquires Contracts {
        // gets the creator address
        let creator = signer::address_of(account1);
        // gets the signer address
        //let signer_address = signer::address_of(account2);
        // assert signer has owned a contract 
        assert!(exists<Contracts>(creator), NOT_EXIST);
        // gets the Contracts resource
        let contract_list = borrow_global_mut<Contracts>(creator);
        // assert contract exists
        assert!(table::contains(&contract_list.contract_saved, contract_id), NOT_EXIST);
        // gets the contract matched the contract_id
        let contract_record = table::borrow_mut(&mut contract_list.contract_saved, contract_id);
        // assert contract sign is not completed
        assert!(contract_record.sign == false, ETASK_IS_COMPLETED);
        // update contract sign as completed
        contract_record.sign = true;
    }

    public fun delete_contract(account2: &signer, contract_id:u64) acquires Contracts {
        // gets the signer address
        let signer_address = signer::address_of(account2);
        // assert signer has owned a contract 
        assert!(exists<Contracts>(signer_address), NOT_EXIST);
        // gets the Contracts resource
        let contract_list = borrow_global_mut<Contracts>(signer_address);
        // assert contract exists
        assert!(table::contains(&contract_list.contract_saved, contract_id), NOT_EXIST);
        // gets the contract matched the contract_id and remove contract
        let contract_record = table::remove(&mut contract_list.contract_saved, contract_id);
    }

    struct AuditReports has store, key
    {
        audit_report: Table<u64, AuditReport>,
        audit_report_counter:u64
    }

    #[event]
    struct AuditReport has store, key, drop , copy
    {
        audit_report_id: u64,
        user: address, // general user
        audit_robot: address, //sign by auditor (AI robot)
        audit_signer: address, //sign by auditor (Human)
        contract: String, //hash data for digital contract
        audit_report: String, //hash data for audit report
        sign: bool, //sign by auditor (Human)
    }

    public entry fun create_audit_database(account: &signer) {
        let new_audit_database = AuditReports {
            audit_report: table::new(),
            audit_report_counter: 0
        };
        // move the Audits resource under the signer account
        move_to(account, new_audit_database);
    }

    public entry fun add_audit_report(audit_report_id: u64, user: &signer, audit_robot: &signer, audit_signer: &signer, contract:String, audit_report:String, sign:bool) acquires AuditReports {
        //let audit_report_id = audit_report_id;
        // gets the user address
        let user = signer::address_of(user);
        // gets the robot address
        let audit_robot = signer::address_of(audit_robot);
        // gets the audit signer address
        let audit_signer = signer::address_of(audit_signer);
        // assert user has created a list
        assert!(exists<AuditReports>(user), NOT_INITIALIZED);
        // gets the AuditReports resource
        let audit_reports_list = borrow_global_mut<AuditReports>(user);
        // increment contract counter
        let counter = audit_reports_list.audit_report_counter + 1;
        // creates a new Contract
        let newAuditReport = AuditReport {
        audit_report_id: audit_report_id,
        user: user, // general user
        audit_robot: audit_robot, //sign by auditor (AI robot)
        audit_signer: audit_signer, //sign by auditor (Human)
        contract: contract, //hash data for digital contract
        audit_report: audit_report, //hash data for audit report
        sign: sign, //sign by auditor (Human)
        };
        // adds the new audit report into the audit report database
        table::upsert(&mut audit_reports_list.audit_report, counter, newAuditReport);
        // sets the audit report counter to be the incremented counter
        audit_reports_list.audit_report_counter = counter;
        // a new audit report created event
        event::emit(newAuditReport);
    }

    public entry fun update_audit_report(audit_signer: &signer, audit_report_id:u64) acquires AuditReports {
        // gets the audit_ igner address
        let audit_signer = signer::address_of(audit_signer);
        // assert audit signer has owned a contract 
        assert!(exists<AuditReports>(audit_signer), NOT_EXIST);
        // gets the AuditReports resource
        let audit_report_list = borrow_global_mut<AuditReports>(audit_signer);
        // assert AuditReport exists
        assert!(table::contains(&audit_report_list.audit_report, audit_report_id), NOT_EXIST);
        // gets the contract matched the contract_id
        let audit_report = table::borrow_mut(&mut audit_report_list.audit_report, audit_report_id);
        // assert contract sign is not completed
        assert!(audit_report.sign == false, ETASK_IS_COMPLETED);
        // update contract sign as completed
        audit_report.sign = true;
    }

    #[view]
    public fun get_next_multisig_account_address(creator: address): address {
    let seed = x"01";
    let owner_nonce = account::get_sequence_number(creator);
    account::create_resource_address(&creator, seed)
}
    //test section
    #[test(a = @0xC0FFEE, b = @0xCAFE)]
    fun test_create_contract(a:signer, b:signer) acquires Contracts
    {
        create_contract(&a);
        //add_contract(&a, &b, 1 ,string::utf8(b"hello99"),false);
        let contracts = borrow_global<Contracts>(signer::address_of(&a));
        let contract = table::borrow(&contracts.contract_saved, 1);
        //add_contract(&a, &b, 12 ,string::utf8(b"hello12"),false);
        assert!(contracts.contract_counter == 1, 5);
        //update_contract(&a, 1);
        assert!(contract.sign == false, 5);
        //delete_contract(&a, 1);
    }
    
}