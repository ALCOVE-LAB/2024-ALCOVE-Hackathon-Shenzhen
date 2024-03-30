# Identifiable NFT ( iNFT in short ) Viewer

- 可识别的NFT的编辑期，支持直接发布iNFT的模板。

## 获取授权

## Mint的过程

- 写链的数据结构

    ```Javascript
        {
            raw:{
                tpl:"anchor://aabb/217148"
            },
            protocol:{
                type:"mint",
                fmt:"json",
            }
        }
    ```

- 解析的过程