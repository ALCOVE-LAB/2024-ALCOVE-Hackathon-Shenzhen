import React, { useState } from 'react';
import { AppstoreOutlined, MailOutlined, SettingOutlined } from '@ant-design/icons';
import type { MenuProps } from 'antd';
import { Menu } from 'antd';
import { Outlet, useLocation, useNavigate } from "react-router-dom";
import { FileOutlined, FlagOutlined } from '@ant-design/icons'; // 导入 FileOutlined 组件

type MenuItem = Required<MenuProps>['items'][number];


const items: MenuItem[] = [
	{
		label: 'Buy',
		key: '/home',
		icon: <MailOutlined />,
	},
	{
		label: 'Puhlish',
		key: '/publish',
		icon: <AppstoreOutlined />,
		// disabled: true,
	},
	{
		label: 'Marktting',
		key: '/marktting',
		icon: <SettingOutlined />,
		disabled: true,
		children: [

			{
				label: 'Option 1',
				key: '/marktting/1',
			},
			{
				label: 'Option 2',
				key: '/marktting/2',
			},
			{
				label: 'Option 3',
				key: '/marktting/3',
			},
			{
				label: 'Option 4',
				key: '/marktting/4',
			},
		],
	},
];

const App: React.FC = () => {

	// 使用组件实现跳转
	const navigateto = useNavigate();

	const currentRoute = useLocation();


	const menuClick = (e: { key: string }) => {
		console.log('点击了菜单', e.key);
		// 点击后跳转到对应的路由, 编程式导航跳转, 利用一个 hook
		navigateto(e.key)
	}
	// 拿着 currentRouter.pathname 跟 items 数组的每一项的 children 的 key 值对比, 
	// 如果找到了相等的值, 那么就获取它的上一级的 key 给 openKeys 的数组元素作为初始值

	let firstOpenKey: string = ""
	// 对比 find
	function findKey(obj: { key: string }) {
		return obj.key === currentRoute.pathname;
	};
	// 要对比多个 children 遍历,
	// for (let i = 0; i < items.length; i++) {
	// 	if (items[i] ? ['children'] && items[i] ? ['children'].length > 1 && items[i] ? ['children'].find(findKey)) {
	// 	// if (items[i] ? ['children'].find(findKey()) : Boolean) {  // 如果拿得到, 找到的就是一个对象, 转布尔值就是true, 否则就是 false

	// 		// if (items[i]!.children && items[i]?.children.find(findKey)) {
	// 		firstOpenKey = items[i]!.key as string;
	// 		break;

	// 	}
	// }
	// items[]['children'].find(findKey); 


	// 设置展开项的初始值  
	const [openKeys, setOpenKeys] = useState([firstOpenKey]);
	const handleOpenChange = (keys: string[]) => {
		// 展开和回收某项菜单的时候执行这里的代码
		console.log('点击了展开', keys); // keys是一个数组, 记录了当前哪一项是展开的, 用 key 来记录
		// 把这个数组修改为最后一项, 因为只要一项是展开的
		setOpenKeys([keys[keys.length - 1]])
	}


	return (
		<>
			<Menu
				// 默认选项
				defaultSelectedKeys={[currentRoute.pathname]}
				mode="horizontal"
				items={items}
				// 点击页面跳转
				onClick={menuClick}
				// 展开回收的事件
				onOpenChange={handleOpenChange}
				// 当前菜单展开项的 key 数组
				openKeys={openKeys} />
			<Outlet />

		</>

	)
};

export default App;


// -----------------------------------------
