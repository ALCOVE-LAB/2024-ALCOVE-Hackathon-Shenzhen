import { useEffect, useState } from "react";
import Waterfall, { TOptions } from "charge-waterfall";
import { useWallet } from "@aptos-labs/wallet-adapter-react";
import { APTOS_COIN, Account, AccountAddress, AccountAddressInput, Aptos, AptosConfig, Hex, HexInput, Network, NetworkToNetworkName, isNull } from "@aptos-labs/ts-sdk";
import { Button } from "antd";
import "./buy.css"


const moduleAddress = "0x46ba3e0479d50653d06217e7ca04f08bbd9f68d556087395149195642e451f0b";

function App() {
	const {
		connect,
		account,
		network,
		connected,
		disconnect,
		wallet,
		wallets,
		signAndSubmitTransaction,
		// signAndSubmitBCSTransaction,
		signTransaction,
		signMessage,
		signMessageAndVerify,
	} = useWallet();
	const [isLoading, setIsLoading] = useState(false);
	const aptosConfig = new AptosConfig({ network: Network.TESTNET });
	const aptos = new Aptos(aptosConfig);

	// ---------------------------------------------------------------------------------------------
	let resource;
	// 获取 NFT 列表
	const get_nft_list = async () => {
		try {
			resource = await aptos.getAccountResource({
				// accountAddress: "0x1", // 账户的地址 这个账户下这个资源
				// resourceType: "0x1::coin::CoinStore<0x1::aptos_coin::AptosCoin>" // 账户地址的 resources 可以看到
				accountAddress: moduleAddress as AccountAddressInput,
				resourceType: `${moduleAddress}::func::NFT`
			});
			console.log(resource);
		} catch (error) {
			console.log(error)
		}
	}
	const buy_a_voucher = async () => {
		try {
			let resource = await signAndSubmitTransaction({ // 交易的签名和提交
				data: {
					function: `${moduleAddress}::call_fun::insert_test_nft`,
					functionArguments: [], // 合约的参数
				},
			});
		} catch (error) {
			console.error(error)
		}
	}

	// 用户购买 NFT
	const users_buy_nft = async () => {

		try {
			let resource = await signAndSubmitTransaction({ // 交易的签名和提交
				data: {
					function: `${moduleAddress}::call_fun::users_buy_nft`,
					functionArguments: ['collection_name', 'https://www.caoyang2002.top/usr/uploads/2023/08/4079902677.jpg', 'nft_name', 'license_name'], // 合约的参数
				},
			});
			// if you want to wait for transaction
			// try {
			// 	await aptos.waitForTransaction({ transactionHash: response.hash });
			// } catch (error) {
			// 	console.error(error);
			// }

			console.log(resource);
		} catch (error) {
			console.log(error);
		}
	}
	// 查询测试数据
	// const get_all_nft = async () => {
	// 	try {
	// 		let resource = await signAndSubmitTransaction({ // 交易的签名和提交
	// 			data: {
	// 				function: `${moduleAddress}::call_fun::get_nft_list`,
	// 				functionArguments: [], // 合约的参数
	// 			},
	// 		});
	// 		// if you want to wait for transaction
	// 		// try {
	// 		// 	await aptos.waitForTransaction({ transactionHash: response.hash });
	// 		// } catch (error) {
	// 		// 	console.error(error);
	// 		// }

	// 		console.log(resource);
	// 	} catch (error) {
	// 		console.log(error);
	// 	}
	// }


	// 休眠的时间
	const sleep = (wait = 1000) => {
		return new Promise((resolve) => {
			setTimeout(resolve, wait);
		});
	};



	interface CardInfo {
		nftUrl: string;
		nftName: string;
		depositAmount: number,
		sellingPrice: number,
		createTime: number,
		validityPeriod: number,
	}

	function displayCard(
		nftUrl: string,
		nftName: string,
		depositAmount: number,
		sellingPrice: number,
		createTime: number,
		validityPeriod: number,
	): void {
		const cardInfo: CardInfo = {
			nftUrl,
			nftName,
			depositAmount,
			sellingPrice,
			createTime,
			validityPeriod
		};

		// 创建模态框的 HTML 结构
		const modalContainer = document.createElement("div");
		modalContainer.classList.add("modal");

		const modalContent = document.createElement("div");
		modalContent.classList.add("modal-content");

		const imageElement = document.createElement("img");
		imageElement.src = cardInfo.nftUrl;
		imageElement.alt = cardInfo.nftName;
		modalContent.appendChild(imageElement);
		// nft 的 名称
		const nameElement = document.createElement("p");
		nameElement.textContent = cardInfo.nftName;
		modalContent.appendChild(nameElement);

		// nft 的 url
		const nftUrlElement = document.createElement("p");
		nftUrlElement.textContent = cardInfo.nftUrl;
		modalContent.appendChild(nftUrlElement);
		// 押金
		const depositAmountElement = document.createElement("p");
		depositAmountElement.textContent = cardInfo.depositAmount as unknown as string;
		modalContent.appendChild(depositAmountElement);

		// 	有效时长
		const validityPeriodElement = document.createElement("p");
		validityPeriodElement.textContent = cardInfo.validityPeriod as unknown as string;
		modalContent.appendChild(validityPeriodElement);

		// 	出售价格
		const sellingPriceElement = document.createElement("p");
		sellingPriceElement.textContent = cardInfo.sellingPrice as unknown as string;
		modalContent.appendChild(sellingPriceElement);


		// 添加关闭按钮
		const closeButton = document.createElement("button");
		closeButton.textContent = "关闭";
		closeButton.onclick = function () {
			modalContainer.style.display = "none";
			document.body.removeChild(modalContainer);
		};
		modalContent.appendChild(closeButton);

		// 添加其他操作按钮
		const actionButton = document.createElement("button");
		actionButton.textContent = "购买";
		actionButton.onclick = function () {
			// 在这里执行其他操作
			users_buy_nft();
			console.log("执行其他操作");
		};
		modalContent.appendChild(actionButton);

		// modalContainer.appendChild(modalContent);
		modalContainer.appendChild(modalContent);

		// 添加模态框到页面
		document.body.appendChild(modalContainer);

		// 显示模态框
		modalContainer.style.display = "block";

		// 点击模态框外部关闭模态框
		window.onclick = function (event) {
			if (event.target == modalContainer) {
				modalContainer.style.display = "none";
				document.body.removeChild(modalContainer);
			}
		}
	}

	// 调用示例
	// const imageUrl = "https://example.com/image.jpg";
	// const name = "示例图片";

	useEffect(() => {
		const waterfall = new Waterfall({
			container: ".container",

			initialData: [
				{
					src:
						"https://www.caoyang2002.top/usr/uploads/2023/08/4079902677.jpg",
					data: {
						title: "一个 NFT 图片",
						license_name: "协议名称",
						nft_name: "NFT 名称",
						user_addr: "用户地址",
						deposit_amount: "押金 10.000",
						selling_price: "出售价格：1.000",
						create_time: "当前时间",
						validity_period: "有效时长：1小时20分钟",
						is_nft_expired: false,
					},
					alt: "图片裂开时加载的文字",

				}, {
					src:
						"https://www.caoyang2002.top/usr/uploads/2023/08/4079902677.jpg",
				}, {
					src:
						"https://www.caoyang2002.top/usr/uploads/2023/08/4079902677.jpg",
				}, {
					src:
						"https://www.caoyang2002.top/usr/uploads/2023/08/4079902677.jpg",
				}, {
					src:
						"https://www.caoyang2002.top/usr/uploads/2023/08/4079902677.jpg",
				}, {
					src:
						"https://www.caoyang2002.top/usr/uploads/2023/08/4079902677.jpg",
				}, {
					src:
						"https://www.caoyang2002.top/usr/uploads/2023/08/4079902677.jpg",
				}, {
					src:
						"https://www.caoyang2002.top/usr/uploads/2023/08/4079902677.jpg",
				}, {
					src:
						"https://www.caoyang2002.top/usr/uploads/2023/08/4079902677.jpg",
				}, {
					src:
						"https://www.caoyang2002.top/usr/uploads/2023/08/4079902677.jpg",
				}, {
					src:
						"https://www.caoyang2002.top/usr/uploads/2023/08/4079902677.jpg",
				}, {
					src:
						"https://www.caoyang2002.top/usr/uploads/2023/08/4079902677.jpg",
				}, {
					src:
						"https://www.caoyang2002.top/usr/uploads/2023/08/4079902677.jpg",
				}, {
					src:
						"https://www.caoyang2002.top/usr/uploads/2023/08/4079902677.jpg",
				}, {
					src:
						"https://www.caoyang2002.top/usr/uploads/2023/08/4079902677.jpg",
				}, {
					src:
						"https://www.caoyang2002.top/usr/uploads/2023/08/4079902677.jpg",
				}, {
					src:
						"https://www.caoyang2002.top/usr/uploads/2023/08/4079902677.jpg",
				}, {
					src:
						"https://www.caoyang2002.top/usr/uploads/2023/08/4079902677.jpg",
				}, {
					src:
						"https://www.caoyang2002.top/usr/uploads/2023/08/4079902677.jpg",
				},

			],
			resizable: true,
			bottomDistance: 200,
			column: 4,
			gapX: 10, //元素水平见的距离
			gapY: 10,
			width: 160, //容器宽度
			defaultImgUrl: "https://www.caoyang2002.top/usr/uploads/2023/08/4079902677.jpg",
			render: () => `<div>price: 10 APT</div>`,
			onClick: (data: any, event: any) => {
				// console.log(data, event);
				console.log(data.src, data.data.nft_name)
				displayCard(data.src,
					data.data.nft_name,
					data.data.deposit_amount,
					data.data.selling_price,
					data.data.create_time,
					data.data.validity_period
				);
			},


		});

		// 这里的_isLoading是防止触底重复多次请求的
		let _isLoading = false;
		waterfall.onReachBottom(async () => {
			if (_isLoading) return;
			_isLoading = true;
			console.log("触底");
			// 这里的setIsLoading是用来做Loading状态渲染的
			setIsLoading(true);
			// 模拟一个异步请求，拿到异步请求的数据之后塞进loadMore里面
			await sleep(2000);
			setIsLoading(false);
			// 异步请求拿到数据之后就可以通过loadMore方法插入了
			waterfall.loadMore([
				{
					// src: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Flmg.jj20.com%2Fup%2Fallimg%2F1114%2F041621124255%2F210416124255-1-1200.jpg&refer=http%3A%2F%2Flmg.jj20.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1666668021&t=38137d81528162e28293c8a64d5caa56",
					src: "https://www.caoyang2002.top/usr/uploads/2023/08/4079902677.jpg",
					data: {
						name: `${Math.floor(Math.random() * 100)}`,
					},
				},
				{
					// src: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic.jj20.com%2Fup%2Fallimg%2Fmn02%2F1231201I024%2F2012311I024-4.jpg&refer=http%3A%2F%2Fpic.jj20.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1666668021&t=71b04264cbf60717c407550a0db1fef0",
					src: "https://www.caoyang2002.top/usr/uploads/2023/08/4079902677.jpg",
					data: {
						name: `${Math.floor(Math.random() * 100)}`,
					},
				},
			]);
			_isLoading = false;
		});

		return () => {
			waterfall.destroy();

		};
	}, []);



	return (
		<>
			{/* <Button
				onClick={get_nft_list}>
				get NFT list
			</Button>
			<Button
				onClick={users_buy_nft}>
				buy NFT
			</Button> */}
			<div className="container" style={{ width: "1000px" }}></div>
			{isLoading && (
				<div
					style={{
						padding: "20px",
						textAlign: "center",
					}}
				>
					加载更多中...
				</div>
			)}

		</>
	);
}

export default App;













// -----------------------------------------------------------------------------
// import { Button, Card, Col, Row } from 'antd';
// import { count } from 'console';
// import { BADQUERY } from 'dns';
// import React from 'react';
// import "../css/buy.css"

// const jsonData = [
// 	{
// 		"title": "Europe Street beat",
// 		"description": "www.instagram.com",
// 		"imageSrc": "https://os.alipayobjects.com/rmsportal/QBnOOoLaAfKPirc.png"
// 	},
// 	{
// 		"title": "Nature Beauty",
// 		"description": "Enjoy the beauty of nature",
// 		"imageSrc": "https://os.alipayobjects.com/rmsportal/QBnOOoLaAfKPirc.png"
// 	},
// 	{
// 		"title": "City Skyline",
// 		"description": "Explore the city skyline",
// 		"imageSrc": "https://os.alipayobjects.com/rmsportal/QBnOOoLaAfKPirc.png"
// 	}
// ];
// const buy = () => {
// 	console.log("购买的逻辑")
// }
// const { Meta } = Card;
// const View: React.FC = () => (
// 	<>
// 		<h1>购买页面</h1>
// 		<div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(100px, 1fr))', gap: '8px' }}>
// 			{/* <div style={{ width: "100%", columnCount: 5, columnGap: "30px" }}> */}
// 			{jsonData.map((card, index) => (
// 				<>
// 					<Card
// 						key={index}
// 						hoverable
// 						style={{ width: '100%' }}
// 						cover={<img alt={card.title} src={card.imageSrc} />}
// 						onClick={buy}
// 					>
// 						<Meta title={card.title} description={card.description} />
// 					</Card>
// 					<Button
// 						onClick={buy}>
// 						购买
// 					</Button>
// 				</>
// 			))}
// 		</div>

// 	</>
// );

// export default View; from 'antd';

// export default View;