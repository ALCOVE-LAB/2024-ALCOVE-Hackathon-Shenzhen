# Identifiable NFT ( iNFT in short ) Viewer

- 可识别的NFT的编辑期，支持直接发布iNFT的模板

## Feather

- Need to load **W3API** from local, need to link the API folder to `node_modules`. Be careful, when new package is added to the project, you need to relink the folder.

    ```SHELL
        # change to node_modules folder of UI
        cd node_modules
        
        # add link to NPM
        ln -s ../../../APIs ./w3api
    ```

## 经济模型

- iNFT的作者发布一个iNFT模版，可以供其他使用者使用，每mint一次，就支付一定的费用给作者。**在Anchor上的难点是，如何触发自动付款给作者。**

- iNFT实例化的结果，可以以Anchor的方式进行销售。

## 稀缺度计算

- 设计师需要对一致性图例进行标识，数据结构如下：

    ```Javascript
        //parts的divide值
        const parts=[16,8,12,4]

        //系列计算值，以3个系列为例
        //块可以不属于某个系列。出来的时候，就可以估价了。
        const rare=[
            [   //系列一
                [0,1,2,3,4],    //part1中是系列一的块, n0=5
                [0,4],          //part2中是系列一的块, n1=2
                [0,1,12],       //part3中是系列一的块, n2=3
                [0,1]           //part4中是系列一的块, n3=2
            ],
            [...],  //系列二，和系列一数据结构一致
            [...]   //系列三，和系列一数据结构一致
        ]
        const target=rare[0];   //如果命中在系列一里
        const rate=(target[0].length/parts[0])
            *(target[1].length/parts[1])
            *(target[2].length/parts[2])
            *(target[3].length/parts[3])
    ```
