import React from 'react';
import ReactDOM from 'react-dom/client';

import "bootstrap/dist/css/bootstrap.min.css";
import './index.css';

import App from './App';
const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(<App />);

// import { PetraWallet } from "petra-plugin-wallet-adapter";
// import { AptosWalletAdapterProvider } from "@aptos-labs/wallet-adapter-react";
// import App from './App';

// const wallets = [new PetraWallet()];
// const root = ReactDOM.createRoot(document.getElementById('root'));
// root.render(
//     <AptosWalletAdapterProvider plugins={wallets} autoConnect={true}>
//     <App />
//   </AptosWalletAdapterProvider>
// );