import React, { MouseEventHandler, useEffect, useState } from 'react';
import { Button, Checkbox, Col, Input, Layout, List, Row, Spin } from 'antd';
import { WalletSelector } from "@aptos-labs/wallet-adapter-ant-design";
import "@aptos-labs/wallet-adapter-ant-design/dist/index.css";
import { useWallet, InputTransactionData } from "@aptos-labs/wallet-adapter-react";
import { Aptos, AptosConfig, Network } from "@aptos-labs/ts-sdk";
import { wait } from '@testing-library/user-event/dist/utils';
import {type} from "os";

//设置 Aptos 与 testnet 网络交互
const aptosConfig = new AptosConfig({ network: Network.TESTNET });
//初始化一个 Aptos 实例
const aptos = new Aptos(aptosConfig);
// RNFTs 发布的地址
const moduleAddress = "0x3d197d2307d1cfdf3ced702d4a36a19dc19c6f986e41a34cbd5ae2550375a24e";

//创建一个本地状态 Order 来保存我们的订单（具有我们在智能合约上设置的相同属性）：
type Order = {
    orderId: string,
    seller: string,
    price: string,
    token: string,
    completed: boolean
    transtype: boolean
};
type NFTMetadata =
{
    addressStr: string,
    minted_by: string,
    description: string,
    shortName: string,
    monthly_dividend: string
};

type NFTWithMetadata = {
    token: string,
    metadata: NFTMetadata,
    isSelected?: boolean // 新增字段用于追踪是否被选中
    inputPrice?: string; // 用户输入的价格
};

function App() {

    // const { account } = useWallet();
    const [bottomstatue, bottomStatue] = useState<number>(0);
    const [displayMarket, setDisplayMarket] = useState<boolean>(false);
    const [displayPayReq, setDisplayPayReq] = useState<boolean>(false);
    const [displayOwnedNFTs, setDisplayOwnedNFTs] = useState<boolean>(false);
    const [nftName, setNftName] = useState('');
    const [nftDescription, setNftDescription] = useState('');
    const [monthlyDividend, setMonthlyDividend] = useState('');
    // const [orders, setOrders] = useState<Order[]>([]);
    // const [nftsData, setNftsData] = useState<NFTWithMetadata[]>([]);


    //account 对象是 null 如果没有连接帐户;连接帐户时， account 对象将保存帐户信息，包括帐户地址。
    const { account, signAndSubmitTransaction } = useWallet();
    //用于 Spinner 组件以在等待交易时显示。添加本地状态以跟踪事务是否正在进行中：
    const [transactionInProgress, setTransactionInProgress] = useState<boolean>(false);
    //orders本地状态，储存order
    const [orders, setOrders] = useState<Order[]>([]);
    //创建一个保存订单内容的新本地状态：
    const [newOrderToken, setNewOrderToken] = useState<string>("");
    const [newOrderPrice, setNewOrderPrice] = useState<string>("");
    //onWriteTask 函数，每当用户在输入文本中键入内容时都会调用该函数
    const onWriteOrderToken = (event: React.ChangeEvent<HTMLInputElement>) => {
        const value = event.target.value;
        setNewOrderToken(value);
    };
    const onWriteOrderPrice = (event: React.ChangeEvent<HTMLInputElement>) => {
        const value = event.target.value;
        setNewOrderPrice(value);
    };
    const [metadataSet, setMetadataSet] = useState<{ [orderId: number]: NFTWithMetadata }>({});
    const [nftsDatas, setNftsData] = useState<NFTWithMetadata[]>([]);

    const fetchOrders = async (transtype:boolean) => {
        try{
            // alert("fuck bug");
            let combinedOrders = [];
            // 获取RNFTs发布的地址里orders里的order资源
            const OrdersResource = await aptos.getAccountResource(
                {
                    accountAddress:moduleAddress,
                    resourceType:`${moduleAddress}::RNFTs::Orders`
                }
            );
            // 获取RNFTs发布的地址里orders里的ordermetadata资源
            const MetaDsResource = await aptos.getAccountResource(
                {
                    accountAddress:moduleAddress,
                    resourceType:`${moduleAddress}::RNFTs::OrderDataTable`
                }
            );

            //表句柄
            const orderHandleOrder = (OrdersResource as any).orders.handle;
            const orderHandleMetas = (MetaDsResource as any).orders.handle;

            //order计数器，以便我们可以循环并获取与 orderId 匹配的任务 order_counter
            const orderCounter = (OrdersResource as any).order_counter;

            // alert(orderCounter);
            //本地的orders表
            let orders = [];
            let metaDs = [];
            //本地的orders计数器
            let counter = 0;

            while (counter <= orderCounter) {
                counter++;
                // alert("looping bg");
                const orderItem = {
                    key_type: "u64",
                    value_type: `${moduleAddress}::RNFTs::OrderWithMeta`,
                    key: `${counter}`,
                };

                const orderMetaItem = {
                    key_type: "u64",
                    value_type: `${moduleAddress}::RNFTs::NFTWithMetadata`,
                    key: `${counter}`,
                };
                // alert("looping mid");
                // alert(counter);

                try {
                    const order = await aptos.getTableItem<Order>({handle:orderHandleOrder, data:orderItem});
                    const metas = await aptos.getTableItem<NFTWithMetadata>({handle:orderHandleMetas, data:orderMetaItem});

                    if(order.transtype==transtype)
                    {
                        orders.push(order);
                        metaDs[+order.orderId]=metas;
                    }

                }catch (error:any){
                    continue;
                }
                // alert(counter);
                // alert(orderHandleMetas);
                // alert(orderMetaItem.value_type);

                // alert("not crush till pushing");



                // alert(metas.metadata.monthly_dividend);
                // alert(counter);
            }

            setOrders(orders);
            setMetadataSet(metaDs);

        }catch(error: any){

            console.log(error);
        }

    };
    const fetchNFTs = async () => {
        if(!account)
            return;
        try{
            // alert("fuck bug");
            // 获取RNFTs我的地址里OwnedNFTs的资源
            const NFTResources = await aptos.getAccountResource(
                {
                    accountAddress:account.address,
                    resourceType:`${account.address}::RNFTs::OwnedNFTs`
                }
            );

            setNftsData(NFTResources.nftsdata);
            // alert("finish");

        }catch(error: any){
            console.log(error);
        }
    }
    //每当账户信息改变时刷新orders
    useEffect(() => {
        if (bottomstatue===1) {
            fetchOrders(true);
        }
        if (bottomstatue===4) {
            fetchOrders(false);
        }
        if (bottomstatue===2) {
            fetchNFTs();
        }
    }, [account?.address, bottomstatue]);
    const onOrderAdded = async (token:string,price:string,orderType:boolean) => {

        //检查是否连接钱包
        if (!account) return;

        setTransactionInProgress(true);

        alert(token);
        //构建要提交到链的交易数据
        const transaction:InputTransactionData = {
            data: {
                function:orderType?`${moduleAddress}::RNFTs::createOrder`:`${moduleAddress}::RNFTs::creatReverseeOrder`,
                functionArguments:orderType?[token,price]:[token]
            }
        };

        try {
            //签署并往链上提交交易
            const response = await signAndSubmitTransaction(transaction);
            //等待交易
            await aptos.waitForTransaction({transactionHash:response.hash});

        } catch (error) {
            console.log("error",error);
        } finally {
            setTransactionInProgress(false);
            window.location.reload()
        };

    };
    const onOrderPurchased = async (orderId: string) => {

        if (!account) return;

        setTransactionInProgress(true);

        const transaction:InputTransactionData = {
            data: {
                function:`${moduleAddress}::RNFTs::transfer`,
                functionArguments:[orderId]
            }
        };

        try {

            const response = await signAndSubmitTransaction(transaction);

            await aptos.waitForTransaction({transactionHash:response.hash});

            let newOrdes = [...orders];

            for (const order of newOrdes) {
                if (order.orderId === orderId) {
                    newOrdes.splice(newOrdes.indexOf(order), 1);
                }
            };

            setOrders(newOrdes);

        } catch (error) {
            console.log("error",error);
        } finally {
            setTransactionInProgress(false);
            window.location.reload()
        };

    }
    // const onOrderCanceled = async (orderId: string) => {
    //
    //     if (!account) return;
    //
    //     setTransactionInProgress(true);
    //
    //     const transaction:InputTransactionData = {
    //         data: {
    //             function:`${moduleAddress}::RNFTs::cancelOrder`,
    //             functionArguments:[orderId]
    //         }
    //     };
    //
    //     try {
    //
    //         const response = await signAndSubmitTransaction(transaction);
    //
    //         await aptos.waitForTransaction({transactionHash:response.hash});
    //
    //         let newOrdes = [...orders];
    //
    //         for (const order of newOrdes) {
    //             if (order.orderId === orderId) {
    //                 newOrdes.splice(newOrdes.indexOf(order), 1);
    //             }
    //         };
    //
    //         setOrders(newOrdes);
    //
    //     } catch (error) {
    //         console.log("error",error);
    //     } finally {
    //         setTransactionInProgress(false);
    //     }
    // }
    const mintNFT = async () => {
        if (!account) return;

        setTransactionInProgress(true);

        const transaction:InputTransactionData = {
            data: {
                function:`${moduleAddress}::RNFTs::mint`,
                functionArguments:[nftName,nftDescription,nftName,monthlyDividend]
            }
        };

        try {
            const response = await signAndSubmitTransaction(transaction);

            await aptos.waitForTransaction({transactionHash:response.hash});

        } catch (error) {
            console.log("error",error);
        } finally {
            setTransactionInProgress(false);
            window.location.reload();
        };
    }

    return (<>

            {/* 顶部栏，连接钱包按钮 */}
            <Layout>
                <Row align="middle">
                    <Col span={10} offset={2}>
                        <h1>Profiting RWA NFT Market</h1>
                    </Col>
                    <Col span={10} style={{ textAlign: "right", paddingRight: "200px" }}>
                        <WalletSelector />
                    </Col>
                </Row>
            </Layout>

            <Row gutter={[0, 32]} style={{ marginTop: "2rem" }}>
                <Col span={8} offset={8}>
                    <Button onClick={() => { bottomStatue(1);}} type="primary">
                        Show Market
                    </Button>
                    <Button onClick={() => { bottomStatue(2);}} type="primary" style={{ marginLeft: '10px' }}>
                        Show Owned NFTs
                    </Button>
                    <Button onClick={() => { bottomStatue(3); }} type="primary" style={{ marginLeft: '10px' }}>
                        Mint NFT
                    </Button>
                    <Button onClick={() => { bottomStatue(4);}} type="primary"  style={{ marginLeft: '10px' }}>
                        Pay dividend
                    </Button>
                </Col>

                {/* 条件渲染市场或拥有的NFTs */}
                {bottomstatue===1 && (
                    <Col span={16} offset={4}>
                        <List
                            size="default"
                            bordered
                            dataSource={orders}
                            renderItem={(order: Order) => (
                                <List.Item
                                    actions={[
                                        <Button
                                            key="buy"
                                            type="primary"
                                            onClick={() => onOrderPurchased(order.orderId)}
                                        >
                                            Buy
                                        </Button>,
                                    ]}
                                >
                                    <List.Item.Meta
                                        title={`${metadataSet[+order.orderId]?.metadata.shortName || 'NFT Title'}`}
                                        description={`
                            Description: ${metadataSet[+order.orderId]?.metadata.description || 'N/A'} - 
                            Price: ${order.price} 
                                                    `}
                                    />
                                </List.Item>
                            )}
                        />
                    </Col>
                )}
                {bottomstatue===4 && (
                    <Col span={16} offset={4}>
                        <List
                            size="default"
                            bordered
                            dataSource={orders}
                            renderItem={(order: Order) => (
                                <List.Item
                                    actions={[
                                        <Button
                                            key="PAY"
                                            type="primary"
                                            onClick={() => onOrderPurchased(order.orderId)}
                                        >
                                            PAY
                                        </Button>,
                                    ]}
                                >
                                    <List.Item.Meta
                                        title={`${metadataSet[+order.orderId]?.metadata.shortName || 'NFT Title'}`}
                                        description={`
                            Description: ${metadataSet[+order.orderId]?.metadata.description || 'N/A'} - 
                            Price: ${order.price} 
                                                    `}
                                    />
                                </List.Item>
                            )}
                        />
                    </Col>
                )}
                {bottomstatue===2 && (
                    <Col span={8} offset={8}>
                        <List
                            size="default"
                            bordered
                            dataSource={nftsDatas}
                            renderItem={(nft: NFTWithMetadata, index: number) => (
                                <List.Item>
                                    <List.Item.Meta
                                        title={`${nft.metadata.shortName}`}
                                        description={`Description: ${nft.metadata.description} - Monthly Dividend: ${nft.metadata.monthly_dividend} - address: ${nft.metadata.addressStr}`}
                                    />
                                    <Input
                                        placeholder="Price"
                                        value={nft.inputPrice}
                                        onChange={(e) => {
                                            const newPrice = e.target.value;
                                            // 更新对应NFT的价格
                                            setNftsData(nftsDatas.map((item, idx) =>
                                                idx === index ? { ...item, inputPrice: newPrice } : item
                                            ));
                                        }}
                                        style={{ width: 100, marginRight: 10 }}
                                    />
                                    <Button
                                        onClick={(e) => {
                                            e.stopPropagation(); // 防止点击按钮时触发列表项的点击事件
                                            // 在这里调用onOrderAdded函数，并传递用户输入的价格
                                            if (nft.inputPrice) {
                                                onOrderAdded(nft.metadata.addressStr, nft.inputPrice,true);
                                            } else {
                                                alert('请输入价格！');
                                            }
                                        }}
                                    >
                                        上架
                                    </Button>
                                    <Button
                                        onClick={(e) => {
                                            e.stopPropagation(); // 防止点击按钮时触发列表项的点击事件
                                            // 在这里调用onOrderAdded函数，并传递用户输入的价格
                                            onOrderAdded(nft.metadata.addressStr, nft.metadata.monthly_dividend,false);
                                            alert("You are asking NFT publisher to pay the profit. They have right to refuse in case the date doesnt meet pay day")
                                        }}
                                    >
                                        Request dividing pay
                                    </Button>
                                </List.Item>
                            )}
                        />
                    </Col>
                )}
                {bottomstatue===3 && (
                    // 铸造NFT的UI
                    <Col span={8} offset={8}>
                        <Input
                            placeholder="Name"
                            onChange={(e) => setNftName(e.target.value)}
                            value={nftName}
                            style={{ marginBottom: "10px" }}
                        />
                        <Input
                            placeholder="Description"
                            onChange={(e) => setNftDescription(e.target.value)}
                            value={nftDescription}
                            style={{ marginBottom: "10px" }}
                        />
                        <Input
                            placeholder="Monthly Dividend"
                            onChange={(e) => setMonthlyDividend(e.target.value)}
                            value={monthlyDividend}
                            style={{ marginBottom: "10px" }}
                        />
                        <Button
                            type="primary"
                            onClick={mintNFT}
                            disabled={transactionInProgress}
                        >
                            Mint
                        </Button>
                    </Col>
                )}
            </Row>
        </>
    );
}

export default App;