import React from 'react';
import { Button, Form, Input, InputNumber, message, Space } from 'antd';
import { useWallet } from '@aptos-labs/wallet-adapter-react';


const moduleAddress = "0x46ba3e0479d50653d06217e7ca04f08bbd9f68d556087395149195642e451f0b";

const App: React.FC = () => {
	const [form] = Form.useForm();

	const onFinish = () => {
		create_license();
		// publish_NFT();
		console.log(form.getFieldsValue().license_name)
		message.success('提交成功');
	};

	const onFinishFailed = () => {
		message.error('提交失败');
	};

	const onFill = () => {
		form.setFieldsValue({
			license_name: "协议名称",
			nft_name: '测试 NFT',
			nft_url: 'https://www.caoyang2002.top/usr/uploads/2023/08/4079902677.jpg',
			validity_period: 60,
			collection_name: 'collection_name',
			deposit_amount: 1000,
			selling_price: 10000,
		});
	};
	//-------------------------------------------------
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

	// public nft
	const publish_NFT = async () => {
		try {
			let resource = await signAndSubmitTransaction({ // 交易的签名和提交
				data: {
					function: `${moduleAddress}::call_fun::`,
					functionArguments: [], // 合约的参数
				},
			});
		} catch (error) {
			console.error(error)
		}
	}
	// create license
	const create_license = async () => {
		try {
			let resource = await signAndSubmitTransaction({ // 交易的签名和提交
				data: {
					function: `${moduleAddress}::call_fun::create_license`,
					functionArguments: [], // 合约的参数
				},
			});
		} catch (error) {
			console.error(error)
		}
	}



	return (
		<Form
			form={form}
			layout="vertical"
			onFinish={onFinish}
			onFinishFailed={onFinishFailed}
			autoComplete="off"
		>
			<h3> create license</h3>
			<Form.Item
				name="license_name"
				label="license name"
				rules={[{ required: true }, { type: 'string', min: 2 }]}
			>
				<Input placeholder="此 NFT 适配的名称" />
			</Form.Item>

			<h3>create NFT</h3>

			<Form.Item
				name="nft_name"
				label="NFT name"
				rules={[{ required: true }, { type: 'string', min: 2 }]}
			>
				<Input placeholder="此 NFT 的名称" />
			</Form.Item>

			<Form.Item
				name="nft_url"
				label="NFT URL"
				rules={[{ required: true }, { type: 'url', warningOnly: true }, { type: 'string', min: 6 }]}
			>
				<Input placeholder="此NFT 的 URL 地址" />
			</Form.Item>

			<Form.Item
				name="collection_name"
				label="Collection name"
				rules={[{ required: true }, { type: 'string', min: 2 }]}
			>
				<Input placeholder="此 NFT 需要被放入的 Collection（收藏夹）" />
			</Form.Item>

			<Form.Item
				name="validity_period"
				label="validity period"
				rules={[{ required: true }, { type: 'number' }]}
			>
				<InputNumber style={{ width: '100%' }} placeholder="此 NFT 的使用权有效期" />
			</Form.Item>

			<Form.Item
				name="deposit_amount"
				label="deposit amount"
				rules={[{ required: true }, { type: 'number' }]}
			>
				<InputNumber style={{ width: '100%' }} placeholder="用户使用此 NFT 需要支付的押金" />
			</Form.Item>

			<Form.Item
				name="selling_price"
				label="selling price"
				rules={[{ required: true }, { type: 'number' }]}
			>
				<InputNumber style={{ width: '100%' }} placeholder="出售此 NFT 的价格" />
			</Form.Item>



			<Form.Item>
				<Space>
					<Button type="primary" htmlType="submit" >
						提交
					</Button>
					<Button htmlType="button" onClick={onFill}>
						填充
					</Button>
				</Space>
			</Form.Item>
		</Form>
	);
};

export default App;