import { WalletSelector } from "@aptos-labs/wallet-adapter-ant-design";
import { Tabs, Layout, Row, TabsProps, Col, Button, Spin, List, Checkbox, Input, Statistic, Card } from "antd";
import CountUp from 'react-countup';

import React, { useEffect, useState } from "react";
import { useWallet } from "@aptos-labs/wallet-adapter-react";
import Home from "./component/Home"
import "@aptos-labs/wallet-adapter-ant-design/dist/index.css";
import { CheckboxChangeEvent } from "antd/es/checkbox";
import { AptosClient } from "aptos";
import { HomeOutlined, AppstoreOutlined, CompassOutlined, MoneyCollectOutlined, ArrowDownOutlined, ArrowUpOutlined, CommentOutlined, MailOutlined, SettingOutlined } from '@ant-design/icons';
import Community from "./component/community";




type Task = {
  address: string;
  completed: boolean;
  content: string;
  task_id: string;
};

type Formatter = (value: any) => JSX.Element;

const formatter: Formatter = (value: any) => <CountUp end={Number(value)} separator="," />;


export const NODE_URL = "https://fullnode.devnet.aptoslabs.com";
export const client = new AptosClient(NODE_URL);
// change this to be your module account address
export const moduleAddress =
  "0x4d318344b89623a4f28196fff8ffcdc406d0746214553e0111aeed5a89bfa322";

function App() {
  const { account, signAndSubmitTransaction } = useWallet();
  useState<boolean>(false);

  const onChange = (key: string) => {
    console.log(key);
  };

  const items: TabsProps['items'] = [
    {
      key: 'sub1',
      icon: <HomeOutlined />,
      label: 'Home',
      children: < Home account={account} signAndSubmitTransaction={signAndSubmitTransaction} />,
    },
    {
      key: 'sub2',
      label: 'Friends',
      icon: <CommentOutlined />,
      children: 'Content of Tab Pane 2',
    },
    {
      key: 'sub3',
      label: 'Community',
      icon: <AppstoreOutlined />,
      children: < Community account={account} signAndSubmitTransaction={signAndSubmitTransaction} />,
    },
    {
      key: 'sub4',
      label: <a href="https://dexscreener.com/" target="_blank" rel="noopener noreferrer">
        Explore
      </a>,
      icon: <CompassOutlined />,
      children: 'Content of Tab Pane 2',
    },
    {
      key: 'sub5',
      label: 'Massage',
      icon: <MailOutlined />,
      children: 'Content of Tab Pane 2',
    },
    {
      key: 'sub6',
      label: 'Grants',
      icon: <MoneyCollectOutlined />,
      children: 'Content of Tab Pane 2',
    },
    {
      key: 'sub7',
      label: 'Setting',
      icon: <SettingOutlined />,
      children: 'Content of Tab Pane 2',
    },

  ];



  return (
    <>
      <Layout>
        <Row align="middle" style={{ backgroundColor: '#FFFFFF' }}>
          <Col span={10} offset={2}>
            <h1>CommuSA</h1>
          </Col>
          <Col span={12} style={{ textAlign: "right", paddingRight: "200px" }}>
            <WalletSelector />
            <img src="https://avatars.githubusercontent.com/u/132664647?s=400&u=3ce1876ae232bbebe03ee905ab73af2e4f7f8566&v=4" style={{ width: '50px', height: '50px', marginBottom: '-20px', marginLeft: '10px' }} alt="logo" />
          </Col>


        </Row>
        <Row wrap={false} style={{ backgroundColor: '#FFFFFF' }}>
          <Col span={12} offset={2}>
            <Tabs defaultActiveKey="1" tabPosition={"left"} items={items} onChange={onChange} />
          </Col>
          <Col span={5} offset={1}>
            <Card bordered={false} title="DINO">

              <Row gutter={6}>
                <Col span={12}>
                  <Statistic title="Active Users" value={2893} valueStyle={{ fontSize: "15px" }} formatter={formatter} />
                </Col>
                <Col span={12}>
                  <Statistic title="Account Balance (USDT)" value={893} valueStyle={{ fontSize: "15px" }} precision={2} formatter={formatter} />
                </Col>
              </Row>
              <Row gutter={6}>
                <Col span={12}>
                  <Statistic
                    title="5M"
                    value={11.28}
                    precision={2}
                    valueStyle={{ color: '#3f8600', fontSize: "15px" }}
                    prefix={<ArrowUpOutlined />}
                    suffix="%"

                  />
                </Col>
                <Col span={12}>
                  <Statistic
                    title="1D"
                    value={899.3}
                    precision={2}
                    valueStyle={{ color: '#3f8600', fontSize: "15px" }}
                    prefix={<ArrowUpOutlined />}
                    suffix="%"
                  />
                </Col>
              </Row>
            </Card>
            <Card bordered={false} title="DUEL">

              <Row gutter={6}>
                <Col span={12}>
                  <Statistic title="Active Users" value={1793} valueStyle={{ fontSize: "15px" }} formatter={formatter} />
                </Col>
                <Col span={12}>
                  <Statistic title="Account Balance (USDT)" value={1.12893} valueStyle={{ fontSize: "15px" }} precision={2} formatter={formatter} />
                </Col>
              </Row>
              <Row gutter={6}>
                <Col span={12}>
                  <Statistic
                    title="5M"
                    value={103.8}
                    precision={2}
                    valueStyle={{ color: '#3f8600', fontSize: "15px" }}
                    prefix={<ArrowUpOutlined />}
                    suffix="%"

                  />
                </Col>
                <Col span={12}>
                  <Statistic
                    title="1D"
                    value={1.3}
                    precision={2}
                    valueStyle={{ color: '#cf1322', fontSize: "15px" }}
                    prefix={<ArrowDownOutlined />}
                    suffix="%"
                  />
                </Col>
              </Row>
            </Card>
            <Card bordered={false} title="DUEL">

              <Row gutter={6}>
                <Col span={12}>
                  <Statistic title="Active Users" value={1793} valueStyle={{ fontSize: "15px" }} formatter={formatter} />
                </Col>
                <Col span={12}>
                  <Statistic title="Account Balance (USDT)" value={1.12893} valueStyle={{ fontSize: "15px" }} precision={2} formatter={formatter} />
                </Col>
              </Row>
              <Row gutter={6}>
                <Col span={12}>
                  <Statistic
                    title="5M"
                    value={103.8}
                    precision={2}
                    valueStyle={{ color: '#3f8600', fontSize: "15px" }}
                    prefix={<ArrowUpOutlined />}
                    suffix="%"

                  />
                </Col>
                <Col span={12}>
                  <Statistic
                    title="1D"
                    value={1.3}
                    precision={2}
                    valueStyle={{ color: '#cf1322', fontSize: "15px" }}
                    prefix={<ArrowDownOutlined />}
                    suffix="%"
                  />
                </Col>
              </Row>
            </Card>


          </Col>
        </Row >
      </Layout >


    </>
  );
}

export default App;
