import { Button } from 'antd';
import axios from 'axios';
import React from 'react';
import Form from '../comp/form'
// 定义 GraphQL 查询函数
const fetchGraphQLData = async (query: string, variables: { where_condition: { owner_address: { _eq: string; }; amount: { _gt: number; }; }; offset: number; limit: number; order_by: ({ last_transaction_version: string; token_data_id?: undefined; } | { token_data_id: string; last_transaction_version?: undefined; })[]; }) => {
  try {
    // 发送 POST 请求
    const response = await axios.post('https://api.testnet.aptoslabs.com/v1/graphql/', {
      query,
      variables
    });
    // 返回响应数据
    return response.data;
  } catch (error) {
    // 处理错误
    console.error('GraphQL Request Error:', error);
    throw error; // 抛出错误以便上层处理
  }
};
// 调用查询函数
const query = `
  query getOwnedTokens($where_condition: current_token_ownerships_v2_bool_exp!, $offset: Int, $limit: Int, $order_by: [current_token_ownerships_v2_order_by!]) {
    current_token_ownerships_v2(
      where: $where_condition
      offset: $offset
      limit: $limit
      order_by: $order_by
    ) {
      ...CurrentTokenOwnershipFields
    }
  }

  fragment CurrentTokenOwnershipFields on current_token_ownerships_v2 {
    token_standard
    token_properties_mutated_v1
    token_data_id
    table_type_v1
    storage_id
    property_version_v1
    owner_address
    last_transaction_version
    last_transaction_timestamp
    is_soulbound_v2
    is_fungible_v2
    amount
    current_token_data {
      collection_id
      description
      is_fungible_v2
      largest_property_version_v1
      last_transaction_timestamp
      last_transaction_version
      maximum
      supply
      token_data_id
      token_name
      token_properties
      token_standard
      token_uri
      current_collection {
        collection_id
        collection_name
        creator_address
        current_supply
        description
        last_transaction_timestamp
        last_transaction_version
        max_supply
        mutable_description
        mutable_uri
        table_handle_v1
        token_standard
        total_minted_v2
        uri
      }
    }
  }
`;

const variables = {
  where_condition: {
    owner_address: { _eq: '0xfad4f3618cad1a4f4b5d0dd5d40a883bd421070ac8b35d176c8788d0252bdd8c' },
    amount: { _gt: 0 }
  },
  offset: 0,
  limit: 20,
  order_by: [{ last_transaction_version: 'desc' }, { token_data_id: 'desc' }]
};

let accountData: any;
const fetchContractAddress = async () => {
  try {
    await fetchGraphQLData(query, variables)
      .then(data => {
        accountData = data;
        console.log('Response:', data);
      })
      .catch(error => {
        console.error('Error:', error);
      });
    return accountData;
  } catch {
    return null;
  }

};


const View: React.FC = () => (
  <div>
    <h2>publish NFT</h2>
    <Form />
  </div>
);

export default View;