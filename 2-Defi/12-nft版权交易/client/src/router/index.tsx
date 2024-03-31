import { Navigate } from "react-router-dom";
import Home from "../views/Home";
import NotFound from "../views/NotFound";
import React, { lazy } from "react";
// import Publish from "../views/Publish";
import Buy from "../views/Buy";

const Publish = lazy(() => import("../views/Publish"));
// 懒加载的模式需要给他添加 loding 组件
const withLoading = (comp: JSX.Element) => (
	<React.Suspense fallback={
		<div>loading...</div>
	}>
		{comp}
	</React.Suspense>
)

const routes = [
	{
		path: '/', // 访问 / 路径，重定向到  /home 页面
		element: <Navigate to="/home"></Navigate>

	},
	{
		path: '/', // 访问 /home 路径，进入 Home 页面
		element: <Home />,
		children: [
			{
				path: '/home',
				element: <Buy />,
			},

			{
				path: '/publish',
				element: withLoading(<Publish />)
			},
		]
	},
	{
		path: '*',
		element: <NotFound />,
	}
];
export default routes;