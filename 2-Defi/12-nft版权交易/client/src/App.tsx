import React from 'react';
import logo from './logo.svg';
import './App.css';
import { Layout, Row, Col } from "antd"; // 顶部导入
import { WalletSelector } from "@aptos-labs/wallet-adapter-ant-design";
// import "@aptos-labs/wallet-adapter-ant-design/dist/index.css";
import routes from './router';
import { Route, Routes, useRoutes } from 'react-router-dom';

function App() {
  const routing = useRoutes(routes);
  return (

    <>
      <Layout>
        <Row align="middle">
          <Col span={10} offset={2}>
            <h1>NFT Copyright Transaction</h1>

            {/* <Routes>
              {routes.map((route, index) => (
                <Route key={index} path={route.path} element={route.element} />
              ))}
            </Routes> */}
          </Col>
          <Col span={12} style={{ textAlign: "right", paddingRight: "200px" }}>
            <WalletSelector />
          </Col>
        </Row>
        <Row>
          <Col span={10} offset={2}>
            <>
              {routing}
            </>
          </Col>
        </Row>
      </Layout>
    </>
  );
}

export default App;




// // 测试路由
// import React from 'react';
// import { BrowserRouter as Router, Routes, Route, useRoutes } from 'react-router-dom';
// // 倒入路由
// import routes from './router';



// function App() {
//   const routing = useRoutes(routes);

//   return (
//     // <Router>
//     //   <Routes>
//     //     {routes.map((route, index) => (
//     //       <Route key={index} path={route.path} element={route.element} />
//     //     ))}
//     //   </Routes>
//     // </Router>
//     // <Router>
//     <>
//       {routing}
//     </>
//     // </Router>
//   );
// }

// export default App;