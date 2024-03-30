const template={
    type:2,                 //{1:"1D",2:"2D iNFT",3:"3D iNFT"}
    size:[400,400],         //iNFT输出的尺寸大小
    cell:[50,50],           //每个像素点的大小
    grid:[8,20],            //整体图像的像素
    image:"BASE64_IMAGE",
    parts:[
        "iNFT_PARTS",
        "iNFT_PARTS",
    ]
}

const definition={
    "type":"2D",                //iNFT的组件类型    
    "size":[400,400], 
    "cell":[50,50],
    "grid":[8,20],
    "parts":{
        "piece":{
            "value":[
                "START",
                "STEP",
                "DIVIDE",
                "OFFSET"
            ],
            "img":[
                "LINE",
                "ROW",
                "LINE_EXT",
                "ROW_EXT"
            ],
            "position":[
                "POSITION_X",
                "POSITION_Y"
            ],
            "center":[
                "X",
                "Y"
            ],
            "rotation":[            //图像旋转的角度
                0,                  //旋转角度，以Pi来计
                0.5,                //以什么位置来旋转
                0.5,                //以什么位置来旋转
            ],           
            "scale":1,              //图像拼接时候的缩放比例
            "fill":1,               //是否对背景进行填充
            "color":[               //色彩选择的参数配置，和fill配合使用；使用RGB来实现
                "START",            
                "STEP",             //默认为6，否则需要被3整除
                "DIVIDE",           //单色拆分成多少种
                [
                    "RED_OFFSET",
                    "GREEN_OFFSET",
                    "BLUE_OFFSET"
                ]
            ]
        },
        "draw":{

        },
    },
    "series":[
        {
            "name":"color",
            "desc":""
        },
        {
            "name":"line",
            "desc":""
        },
        {
            "name":"live",
            "desc":""
        }
    ],
    "puzzle":[
            {
                "value":[0,2,8],
                "img":[0,0,0,0],
                "center":[0,0],
                "position":[100,60],
                "rotation":0,
                "rarity":[
                    [0,1,2],
                    [3,5,6],
                    [4,7]
                ]
            },
            {
                "value":[2,2,16],
                "img":[0,1,1,1],
                "center":[0.5,0.5],
                "position":[89,300],
                "rotation":0,
                "rarity":[
                    [0,1,2],
                    [3,4,5,6],
                    [5,6,7]
                ]
            },
            {
                "value":[4,2,16],
                "img":[0,2,0,0],
                "center":[0.5,0.5],
                "position":[300,100],
                "rotation":0,
                "rarity":[
                    [0,1,2,3],
                    [3,4,5,6],
                    [2,5,7]
                ]
            },
            {
                "value":[16,4,12],
                "img":[0,3,1,0],
                "center":[0.5,0.5],
                "position":[200,130],
                "rotation":0,
                "rarity":[
                    [0,1,2],
                    [3,4,5,6],
                    [7]
                ]
            },
            {
                "value":[24,2,16],
                "img":[0,5,1,1],
                "center":[0.5,0.5],
                "position":[230,200],
                "rotation":0,
                "rarity":[
                    [0,1,2,3],
                    [4,5],
                    [6,7]
                ]
            }
        ],
    "version":"1.0.0",
    "auth":["AUTH_NAME"]
}