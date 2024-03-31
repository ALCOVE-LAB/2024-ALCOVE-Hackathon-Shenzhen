/* eslint-disable no-console */
import { Layout, Row, Col, Button, Card, Space, Spin, List, Checkbox, Input, Form, type FormProps } from "antd";
import { WalletSelector } from "@aptos-labs/wallet-adapter-ant-design";
import "@aptos-labs/wallet-adapter-ant-design/dist/index.css";
import React, { useEffect, useState } from "react";
import { CheckboxChangeEvent } from "antd/es/checkbox";

import { sha3_256 as sha3Hash } from "@noble/hashes/sha3";
import {
  Account,
  Aptos,
  AptosConfig,
  Network,
  NetworkToNetworkName,
  MoveString,
  generateTransactionPayload,
  generateRawTransaction,
  TransactionPayloadMultiSig,
  MultiSig,
  AccountAddress,
  InputViewFunctionData,
} from "@aptos-labs/ts-sdk";
import { InputTransactionData, useWallet } from "@aptos-labs/wallet-adapter-react";

import TypewriterComponent from "typewriter-effect";

import { UserOutlined } from '@ant-design/icons';

import Popup from 'reactjs-popup';
import 'reactjs-popup/dist/index.css';

type Task = {
  creator: string;
  sign: boolean;
  content: string;
  contract_signer: string;
  contract_id: string;
};

export const moduleAddress = "0x862df6b2346463039589216fb84b4618b76f2b4e8bd479555863d8ea51606501";

function App() {
  // Default to devnet, but allow for overriding
  const APTOS_NETWORK: Network = Network.DEVNET;

  // Setup the client
  const config = new AptosConfig({ network: APTOS_NETWORK });
  const aptos = new Aptos(config);

  const { account, signAndSubmitTransaction } = useWallet();
  //const { account: owner1, signAndSubmitTransaction } = useWallet();
  // Generate 3 accounts that will be the owners of the multisig account.

  const owner1 = account;
  //console.log(JSON.stringify(owner1));
  console.log(JSON.stringify(owner1));
  const owner2 = Account.generate();
  const owner3 = Account.generate();

  // Global var to hold the created multi sig account address
  let multisigAddress: string;

  // Generate an account that will recieve coin from a transfer transaction
  const recipient = Account.generate();

  // Global var to hold the generated coin transfer transaction payload
  let transactionPayload: TransactionPayloadMultiSig;

  // Generate an account to add and then remove from the multi sig account
  const owner4 = Account.generate();

  // HELPER FUNCTIONS //

  const getNumberOfOwners = async (): Promise<void> => {
    const multisigAccountResource = await aptos.getAccountResource<{ owners: Array<string> }>({
      accountAddress: multisigAddress,
      resourceType: "0x1::multisig_account::MultisigAccount",
    });
    console.log("Number of Owners:", multisigAccountResource.owners.length);
  };

  const getSignatureThreshold = async (): Promise<void> => {
    const multisigAccountResource = await aptos.getAccountResource<{ num_signatures_required: number }>({
      accountAddress: multisigAddress,
      resourceType: "0x1::multisig_account::MultisigAccount",
    });
    console.log("Signature Threshold:", multisigAccountResource.num_signatures_required);
  };

  const fundOwnerAccounts = async () => {
    if (owner1?.address === undefined) return;
    await aptos.fundAccount({ accountAddress: owner1!.address, amount: 100_000_000 });
    await aptos.fundAccount({ accountAddress: owner2.accountAddress, amount: 100_000_000 });
    await aptos.fundAccount({ accountAddress: owner3.accountAddress, amount: 100_000_000 });
    console.log(`owner1: ${owner1!.address.toString()}`);
    console.log(`owner2: ${owner2.accountAddress.toString()}`);
    console.log(`owner3: ${owner3.accountAddress.toString()}`);
  };

  const settingUpMultiSigAccount = async () => {
    if (owner1?.address === undefined) return;

    const payload: InputViewFunctionData = {
      function: "0x1::multisig_account::get_next_multisig_account_address",
      functionArguments: [owner1!.address],
    };
    [multisigAddress] = await aptos.view<[string]>({ payload });

    let res = await signAndSubmitTransaction({
      data: {
        function: "0x1::multisig_account::create_with_owners",
        functionArguments: [
          [owner2.accountAddress.toString(), owner3.accountAddress.toString()],
          2,
          ["Testing"],
          ["SDK"],
        ],
      },
    })

    await aptos.waitForTransaction({ transactionHash: res.hash });

    console.log("Multisig Account Address:", multisigAddress);

    // should be 2
    //await getSignatureThreshold();

    // should be 3
    //await getNumberOfOwners();
  };

  const fundMultiSigAccount = async () => {
    console.log("Funding the multisig account...");
    // Fund the multisig account for transfers.
    await aptos.fundAccount({ accountAddress: multisigAddress, amount: 100_000_000 });
  };

  //submit digital contract to blockchain
  const createMultiSigTransferTransaction = async () => {
    console.log("Creating a multisig transaction to submit digital contract to blockchain...");

    transactionPayload = await generateTransactionPayload({
      multisigAddress,
      function: "0x1::aptos_account::transfer",
      functionArguments: [recipient.accountAddress, 1_000_000],
      aptosConfig: config,
    });

    // Build create_transaction transaction
    const createMultisigTx = await aptos.transaction.build.simple({
      sender: owner2.accountAddress,
      data: {
        function: "0x1::multisig_account::create_transaction",
        functionArguments: [multisigAddress, transactionPayload.multiSig.transaction_payload!.bcsToBytes()],
      },
    });
    // Owner 2 signs the transaction
    const createMultisigTxAuthenticator = aptos.transaction.sign({ signer: owner2, transaction: createMultisigTx });
    // Submit the transaction to chain
    const createMultisigTxResponse = await aptos.transaction.submit.simple({
      senderAuthenticator: createMultisigTxAuthenticator,
      transaction: createMultisigTx,
    });
    await aptos.waitForTransaction({ transactionHash: createMultisigTxResponse.hash });
  };

  const executeMultiSigTransferTransaction = async () => {
    // Owner 2 can now execute the transactions as it already has 2 approvals (from owners 2 and 3).
    console.log("Owner 2 can now execute the transfer transaction as it already has 2 approvals (from owners 2 and 3).");

    const rawTransaction = await generateRawTransaction({
      aptosConfig: config,
      sender: owner2.accountAddress,
      payload: transactionPayload,
    });

    const owner2Authenticator = aptos.transaction.sign({ signer: owner2, transaction: { rawTransaction } });
    const transferTransactionReponse = await aptos.transaction.submit.simple({
      senderAuthenticator: owner2Authenticator,
      transaction: { rawTransaction },
    });
    await aptos.waitForTransaction({ transactionHash: transferTransactionReponse.hash });
  };

  const checkBalance = async () => {
    const accountResource = await aptos.getAccountResource<{ coin: { value: number } }>({
      accountAddress: recipient.accountAddress,
      resourceType: "0x1::coin::CoinStore<0x1::aptos_coin::AptosCoin>",
    });

    console.log("Recipient's balance after transfer", accountResource.coin.value);
  };

  const createMultiSigTransferTransactionWithPayloadHash = async () => {
    console.log("Creating another multisig transaction using payload hash...");
    // Step 3: Create another multisig transaction to send 1_000_000 coins but use payload hash instead.
    // ===========================================================================================
    const transferTxPayloadHash = sha3Hash.create();
    transferTxPayloadHash.update(transactionPayload.multiSig.transaction_payload!.bcsToBytes());

    // Build create_transaction_with_hash transaction
    const createMultisigTxWithHash = await aptos.transaction.build.simple({
      sender: owner2.accountAddress,
      data: {
        function: "0x1::multisig_account::create_transaction_with_hash",
        functionArguments: [multisigAddress, transferTxPayloadHash.digest()],
      },
    });
    // Owner 2 signs the transaction
    const createMultisigTxWithHashAuthenticator = aptos.transaction.sign({
      signer: owner2,
      transaction: createMultisigTxWithHash,
    });
    // Submit the transaction to chain
    const createMultisigTxWithHashResponse = await aptos.transaction.submit.simple({
      senderAuthenticator: createMultisigTxWithHashAuthenticator,
      transaction: createMultisigTxWithHash,
    });
    await aptos.waitForTransaction({ transactionHash: createMultisigTxWithHashResponse.hash });
  };

  const executeMultiSigTransferTransactionWithPayloadHash = async () => {
    // Owner 2 can now execute the transactions as it already has 2 approvals (from owners 2 and 3).
    console.log(
      "Owner 2 can now execute the transfer with hash transaction as it already has 2 approvals (from owners 2 and 3).",
    );

    const createTransactionWithHashRawTransaction = await generateRawTransaction({
      aptosConfig: config,
      sender: owner2.accountAddress,
      payload: transactionPayload,
    });

    const owner2Authenticator2 = aptos.transaction.sign({
      signer: owner2,
      transaction: { rawTransaction: createTransactionWithHashRawTransaction },
    });
    const multisigTxExecution2Reponse = await aptos.transaction.submit.simple({
      senderAuthenticator: owner2Authenticator2,
      transaction: { rawTransaction: createTransactionWithHashRawTransaction },
    });
    await aptos.waitForTransaction({ transactionHash: multisigTxExecution2Reponse.hash });
  };

  const createAddingAnOwnerToMultiSigAccountTransaction = async () => {
    console.log("Adding an owner to the multisig account...");

    // Generate a transaction payload as it is one of the input arguments create_transaction expects
    const addOwnerTransactionPayload = await generateTransactionPayload({
      multisigAddress,
      function: "0x1::multisig_account::add_owner",
      functionArguments: [owner4.accountAddress],
      aptosConfig: config,
    });

    // Build create_transaction transaction
    const createAddOwnerTransaction = await aptos.transaction.build.simple({
      sender: owner2.accountAddress,
      data: {
        function: "0x1::multisig_account::create_transaction",
        functionArguments: [multisigAddress, addOwnerTransactionPayload.multiSig.transaction_payload!.bcsToBytes()],
      },
    });
    // Owner 2 signs the transaction
    const createAddOwnerTxAuthenticator = aptos.transaction.sign({
      signer: owner2,
      transaction: createAddOwnerTransaction,
    });
    // Submit the transaction to chain
    const createAddOwnerTxResponse = await aptos.transaction.submit.simple({
      senderAuthenticator: createAddOwnerTxAuthenticator,
      transaction: createAddOwnerTransaction,
    });
    await aptos.waitForTransaction({ transactionHash: createAddOwnerTxResponse.hash });
  };

  const executeAddingAnOwnerToMultiSigAccountTransaction = async () => {
    // Owner 2 can now execute the transactions as it already has 2 approvals (from owners 2 and 3).
    console.log(
      "Owner 2 can now execute the adding an owner transaction as it already has 2 approvals (from owners 2 and 3).",
    );

    const multisigTxExecution3 = await generateRawTransaction({
      aptosConfig: config,
      sender: owner2.accountAddress,
      payload: new TransactionPayloadMultiSig(new MultiSig(AccountAddress.fromString(multisigAddress))),
    });

    const owner2Authenticator3 = aptos.transaction.sign({
      signer: owner2,
      transaction: { rawTransaction: multisigTxExecution3 },
    });
    const multisigTxExecution3Reponse = await aptos.transaction.submit.simple({
      senderAuthenticator: owner2Authenticator3,
      transaction: { rawTransaction: multisigTxExecution3 },
    });
    await aptos.waitForTransaction({ transactionHash: multisigTxExecution3Reponse.hash });
  };

  const createRemovingAnOwnerToMultiSigAccount = async () => {
    console.log("Removing an owner from the multisig account...");

    const removeOwnerPayload = await generateTransactionPayload({
      multisigAddress,
      function: "0x1::multisig_account::remove_owner",
      functionArguments: [owner4.accountAddress],
      aptosConfig: config,
    });

    // Build create_transaction transaction
    const removeOwnerTx = await aptos.transaction.build.simple({
      sender: owner2.accountAddress,
      data: {
        function: "0x1::multisig_account::create_transaction",
        functionArguments: [multisigAddress, removeOwnerPayload.multiSig.transaction_payload!.bcsToBytes()],
      },
    });

    // Owner 2 signs the transaction
    const createRemoveOwnerTxAuthenticator = aptos.transaction.sign({
      signer: owner2,
      transaction: removeOwnerTx,
    });
    // Submit the transaction to chain
    const createRemoveOwnerTxResponse = await aptos.transaction.submit.simple({
      senderAuthenticator: createRemoveOwnerTxAuthenticator,
      transaction: removeOwnerTx,
    });
    await aptos.waitForTransaction({ transactionHash: createRemoveOwnerTxResponse.hash });
  };

  const executeRemovingAnOwnerToMultiSigAccount = async () => {
    // Owner 2 can now execute the transactions as it already has 2 approvals (from owners 2 and 3).
    console.log(
      "Owner 2 can now execute the removing an owner transaction as it already has 2 approvals (from owners 2 and 3).",
    );

    const multisigTxExecution4 = await generateRawTransaction({
      aptosConfig: config,
      sender: owner2.accountAddress,
      payload: new TransactionPayloadMultiSig(new MultiSig(AccountAddress.fromString(multisigAddress))),
    });
    const owner2Authenticator4 = aptos.transaction.sign({
      signer: owner2,
      transaction: { rawTransaction: multisigTxExecution4 },
    });
    const multisigTxExecution4Reponse = await aptos.transaction.submit.simple({
      senderAuthenticator: owner2Authenticator4,
      transaction: { rawTransaction: multisigTxExecution4 },
    });
    await aptos.waitForTransaction({ transactionHash: multisigTxExecution4Reponse.hash });
  };

  const createChangeSignatureThresholdTransaction = async () => {
    console.log("Changing the signature threshold to 3-of-3...");

    const changeSigThresholdPayload = await generateTransactionPayload({
      multisigAddress,
      function: "0x1::multisig_account::update_signatures_required",
      functionArguments: [3],
      aptosConfig: config,
    });

    // Build create_transaction transaction
    const changeSigThresholdTx = await aptos.transaction.build.simple({
      sender: owner2.accountAddress,
      data: {
        function: "0x1::multisig_account::create_transaction",
        functionArguments: [multisigAddress, changeSigThresholdPayload.multiSig.transaction_payload!.bcsToBytes()],
      },
    });

    // Owner 2 signs the transaction
    const changeSigThresholdAuthenticator = aptos.transaction.sign({
      signer: owner2,
      transaction: changeSigThresholdTx,
    });
    // Submit the transaction to chain
    const changeSigThresholdResponse = await aptos.transaction.submit.simple({
      senderAuthenticator: changeSigThresholdAuthenticator,
      transaction: changeSigThresholdTx,
    });
    await aptos.waitForTransaction({ transactionHash: changeSigThresholdResponse.hash });
  };

  const executeChangeSignatureThresholdTransaction = async () => {
    // Owner 2 can now execute the transactions as it already has 2 approvals (from owners 2 and 3).
    console.log(
      "Owner 2 can now execute the change signature threshold transaction as it already has 2 approvals (from owners 2 and 3).",
    );

    const multisigTxExecution5 = await generateRawTransaction({
      aptosConfig: config,
      sender: owner2.accountAddress,
      payload: new TransactionPayloadMultiSig(new MultiSig(AccountAddress.fromString(multisigAddress))),
    });

    const owner2Authenticator5 = aptos.transaction.sign({
      signer: owner2,
      transaction: { rawTransaction: multisigTxExecution5 },
    });
    const multisigTxExecution5Reponse = await aptos.transaction.submit.simple({
      senderAuthenticator: owner2Authenticator5,
      transaction: { rawTransaction: multisigTxExecution5 },
    });
    await aptos.waitForTransaction({ transactionHash: multisigTxExecution5Reponse.hash });
  };

  const rejectAndApprove = async (aprroveOwner: Account, rejectOwner: Account, transactionId: number): Promise<void> => {
    console.log("Owner 1 rejects but owner 3 approves.");
    const rejectTx = await aptos.transaction.build.simple({
      sender: aprroveOwner.accountAddress,
      data: {
        function: "0x1::multisig_account::reject_transaction",
        functionArguments: [multisigAddress, transactionId],
      },
    });

    const rejectSenderAuthenticator = aptos.transaction.sign({ signer: aprroveOwner, transaction: rejectTx });
    const rejectTxResponse = await aptos.transaction.submit.simple({
      senderAuthenticator: rejectSenderAuthenticator,
      transaction: rejectTx,
    });
    await aptos.waitForTransaction({ transactionHash: rejectTxResponse.hash });

    const approveTx = await aptos.transaction.build.simple({
      sender: rejectOwner.accountAddress,
      data: {
        function: "0x1::multisig_account::approve_transaction",
        functionArguments: [multisigAddress, transactionId],
      },
    });

    const approveSenderAuthenticator = aptos.transaction.sign({ signer: rejectOwner, transaction: approveTx });
    const approveTxResponse = await aptos.transaction.submit.simple({
      senderAuthenticator: approveSenderAuthenticator,
      transaction: approveTx,
    });
    await aptos.waitForTransaction({ transactionHash: approveTxResponse.hash });
  };

  const [tasks, setTasks] = useState<Task[]>([]);
  const [newTask, setNewTask] = useState<string>("");
  const [accountHasList, setAccountHasList] = useState<boolean>(false);
  const [transactionInProgress, setTransactionInProgress] = useState<boolean>(false);
  const [contractDatabase, setContractDatabase] = useState<boolean>(false);

  var hash = require('object-hash');
  const [file, setFile] = useState<File | null>(null);
  const hashData = hash.MD5(file);

  const onWriteTask = (event: React.ChangeEvent<HTMLInputElement>) => {
    const value = event.target.value;
    setNewTask(value);
  };

  const fetchList = async () => {
    if (!account) return [];
    try {
      const todoListResource = await aptos.getAccountResource(
        {
          accountAddress: account?.address,
          resourceType: `${moduleAddress}::ContractDatabase::Contracts`
        }
      );
      setAccountHasList(true);
      setContractDatabase(true);
      console.log("todoListResource =" + JSON.stringify(todoListResource));
      // contracts table handle
      //const tableHandle = (todoListResource as any).data.contract_saved.handle;
      const tableHandle = (todoListResource as any).contract_saved.handle;
      console.log(tableHandle);
      // contracts table counter
      const contractCounter = (todoListResource as any).contract_counter;
      console.log(contractCounter);

      let contracts = [];
      let counter = 1;
      while (counter <= contractCounter) {
        const tableItem = {
          key_type: "u64",
          value_type: `${moduleAddress}::ContractDatabase::Contract`,
          key: `${counter}`,
        };
        const contract = await aptos.getTableItem<Task>({ handle: tableHandle, data: tableItem });
        contracts.push(contract);
        counter++;
      }
      // set tasks in local state
      console.log("contracts " + JSON.stringify(contracts));
      setTasks(contracts);
    } catch (e: any) {
      setAccountHasList(false);
    }
  };

  const addNewContract = async () => {
    if (!account) return [];
    setTransactionInProgress(true);

    const transaction: InputTransactionData = {
      data: {
        function: `${moduleAddress}::ContractDatabase::create_contract`,
        functionArguments: []
      }
    }
    try {
      // sign and submit transaction to chain
      const response = await signAndSubmitTransaction(transaction);
      // wait for transaction
      await aptos.waitForTransaction({ transactionHash: response.hash });
      setAccountHasList(true);
    } catch (error: any) {
      setAccountHasList(false);
    } finally {
      setTransactionInProgress(false);
    }
  };

  const onTaskAdded = async () => {
    // check for connected account
    if (!account) return;
    setTransactionInProgress(true);

    const transaction: InputTransactionData = {
      data: {
        function: `${moduleAddress}::ContractDatabase::add_contract`,
        functionArguments: ["0xc5797bd664dc46d75d3f4bbbddbf8e84054c30533119de7906e783d98ddbdd45", hashData as string]
      }
    }

    // hold the latest contract.contract_id from our local state
    const latestId = tasks.length > 0 ? parseInt(tasks[tasks.length - 1].contract_id) + 1 : 1;

    // build a newTaskToPush objct into our local state
    const newTaskToPush = {
      creator: account.address,
      sign: false,
      content: newTask,
      contract_signer: "0xc5797bd664dc46d75d3f4bbbddbf8e84054c30533119de7906e783d98ddbdd45",
      contract_id: latestId + "",
    };

    try {
      // sign and submit transaction to chain
      const response = await signAndSubmitTransaction(transaction);
      // wait for transaction
      await aptos.waitForTransaction({ transactionHash: response.hash });

      // Create a new array based on current state:
      let newTasks = [...tasks];

      // Add item to the tasks array
      newTasks.push(newTaskToPush);
      // Set state
      setTasks(newTasks);
      // clear input text
      setNewTask("");
    } catch (error: any) {
      console.log("error", error);
    } finally {
      setTransactionInProgress(false);
    }
  };

  const onCheckboxChange = async (event: CheckboxChangeEvent, contractId: string) => {
    if (!account) return;
    if (!event.target.checked) return;
    setTransactionInProgress(true);

    const transaction: InputTransactionData = {
      data: {
        function: `${moduleAddress}::ContractDatabase::update_contract`,
        functionArguments: [contractId]
      }
    }

    try {
      // sign and submit transaction to chain
      const response = await signAndSubmitTransaction(transaction);
      // wait for transaction
      await aptos.waitForTransaction({ transactionHash: response.hash });

      setTasks((prevState) => {
        const newState = prevState.map((obj) => {
          // if contract_id equals the checked contractId, update completed property
          if (obj.contract_id === contractId) {
            return { ...obj, completed: true };
          }

          // otherwise return object as is
          return obj;
        });

        return newState;
      });
    } catch (error: any) {
      console.log("error", error);
    } finally {
      setTransactionInProgress(false);
    }
  };

  useEffect(() => {
    fetchList();
  }, [account?.address]);


  const main = async () => {
    //await fundOwnerAccounts();
    ///////////////////////////////////await settingUpMultiSigAccount();
    //await fundMultiSigAccount();

    //await createMultiSigTransferTransaction();
    //await rejectAndApprove(owner1, owner3, 1);
    //await executeMultiSigTransferTransaction();

    // should be 1_000_000
    //await checkBalance();

    //await createMultiSigTransferTransactionWithPayloadHash();
    //await rejectAndApprove(owner1, owner3, 2);
    //await executeMultiSigTransferTransactionWithPayloadHash();

    // should be 2_000_000
    //await checkBalance();

    //await createAddingAnOwnerToMultiSigAccountTransaction();
    //await rejectAndApprove(owner1, owner3, 3);
    //await executeAddingAnOwnerToMultiSigAccountTransaction();

    // should be 4
    //await getNumberOfOwners();

    //await createRemovingAnOwnerToMultiSigAccount();
    //await rejectAndApprove(owner1, owner3, 4);
    //await executeRemovingAnOwnerToMultiSigAccount();

    // should be 3
    //await getNumberOfOwners();

    //await createChangeSignatureThresholdTransaction();
    //await rejectAndApprove(owner1, owner3, 5);
    //await executeChangeSignatureThresholdTransaction();

    // The multisig account should now be 3-of-3.
    //await getSignatureThreshold();

    //console.log("Multisig setup and transactions complete.");

  };

  main();
  return (
    <>
      <main className="h-full bg-[#000000] overflow-auto">
        <div className="mx-auto max-w-screen-xl h-full w-full">
          <nav className="p-4 bg-transparent flex items-center justify-between">

            <div className="relative h-8 w-8 mr-4">
              <Button className="rounded-full" >
                Get Start
              </Button>
            </div>

            <div className="flex items-center gap-x-2">
              <WalletSelector />
            </div>

          </nav>
          <div className="text-white font-bold py-36 text-center space-y-5">
            <div className="text-4xl sm:text-5xl md:text-6xl lg:text-7xl space-y-5 font-extrabold">
              <h1>數字合約驗證及AI審核</h1>
              <div className="text-4xl text-transparent bg-clip-text bg-gradient-to-r from-green-400 to-blue-600">
                <TypewriterComponent
                  options={{
                    strings: [
                      "Prevent altered or deleted",
                      "Verification with ZKP",
                      "AI Audit for your contract",
                      "Protect your benefit."
                    ],
                    autoStart: true,
                    loop: true,
                  }}
                />
              </div>
            </div>
            <div className="text-sm md:text-xl font-light text-zinc-400">
              Enjoy great protection with our applications
            </div>
            <div>

              <Button type="primary" style={{ height: "40px", backgroundColor: "#3f67ff" }}>
                Try it
              </Button>

            </div>
            <div className="text-zinc-400 text-xs md:text-sm font-normal">
              Whitelist will release soon !
            </div>


            <Spin spinning={transactionInProgress}>
              {!accountHasList && !contractDatabase ? (
                <Row gutter={[0, 32]} style={{ marginTop: "2rem" }}>
                  <Col span={8} offset={8}>
                    <Button
                      disabled={!account}
                      block
                      onClick={addNewContract}
                      type="primary"
                      style={{ height: "40px", backgroundColor: "#3f67ff" }}
                    >
                      create contract database
                    </Button>
                  </Col>
                </Row>
              ) : (
                <div className="text-white">
                  <Row gutter={[0, 32]} style={{ marginTop: "2rem" }}>
                    <Col span={8} offset={8}>
                      <Input.Group compact>
                        <Input
                          onChange={(event) => onWriteTask(event)}
                          style={{ width: "calc(100% - 60px)" }}
                          placeholder="enter contract signer"
                          size="large"
                          value={newTask}
                          prefix={<UserOutlined />} />

                        <Input
                          type="file"
                          placeholder="Upload Document"
                          //value={message}
                          onChange={(e) => {
                            if (e.target.files != null) {
                              if (e.target.files.length != 0) {
                                setFile(e.target.files[0]);
                              }
                            }

                          }}
                        />
                        <Button onClick={onTaskAdded} type="primary" style={{ height: "40px", backgroundColor: "#3f67ff" }}>
                          upload new contract
                        </Button>
                      </Input.Group>
                    </Col>
                    <Col span={16} offset={4} >
                      {tasks && (
                        <List
                          size="large"
                          bordered
                          dataSource={tasks}
                          renderItem={(task: Task) => (
                            <List.Item
                              actions={[
                                <div>
                                  {task.sign ? (
                                    <Checkbox defaultChecked={true} disabled />
                                  ) : (
                                    <Checkbox onChange={(event) => onCheckboxChange(event, task.contract_id)} />
                                  )}
                                </div>,
                              ]}
                            >
                              <div className="text-white">
                                <List.Item.Meta
                                  title=""
                                  description={
                                    <a
                                      href={`https://explorer.aptoslabs.com/account/${task.contract_signer}/`}
                                      target="_blank"
                                      className="text-white"
                                    >Contract Signer:{`${task.contract_signer.slice(0, 6)}...${task.contract_signer.slice(-5)}`}</a>
                                  }
                                />
                              </div>
                              <div className="relative h-8 w-8 mr-4">
                                <Popup trigger={<Button className="rounded-full">
                                  Multi Sig
                                </Button>} position="right center">
                                  <Form
                                    name="basic"
                                    labelCol={{ span: 8 }}
                                    wrapperCol={{ span: 16 }}
                                    style={{ maxWidth: 600 }}
                                    initialValues={{ remember: true }}
                                    autoComplete="off"
                                  >
                                    <Form.Item
                                      label="wallet 1"
                                      name="wallet 1"
                                      rules={[{ message: 'user wallet!' }]}
                                    >
                                      <Input />
                                    </Form.Item>

                                    <Form.Item
                                      label="wallet 2"
                                      name="wallet 2"
                                      rules={[{ message: 'user wallet!' }]}
                                    >
                                      <Input />
                                    </Form.Item>

                                    <Form.Item wrapperCol={{ offset: 8, span: 16 }}>
                                      <Button type="primary" htmlType="submit" onClick={settingUpMultiSigAccount}>
                                        Submit
                                      </Button>
                                    </Form.Item>
                                  </Form>
                                </Popup>
                              </div>
                              <div className="text-white">
                                <List.Item.Meta
                                  title=""
                                  description={
                                    <a
                                      href={`https://explorer.aptoslabs.com/account/${task.creator}/`}
                                      target="_blank"
                                      className="text-white"
                                    >
                                      My Contract:
                                      <br />
                                      {task.content}
                                      <br />
                                      {`${task.creator.slice(0, 6)}...${task.creator.slice(-5)}`}</a>
                                  }
                                />
                              </div>
                            </List.Item>
                          )}
                        />
                      )}
                    </Col>
                  </Row>
                </div>
              )}
            </Spin>
          </div>
        </div>
      </main>
    </>
  )
}

export default App;