const map={
    template:null,      //模版image文件, BS64编码
    size:{              //模版对应的数据
        cell:[50,50],       //组件的基础尺寸
        grid:[8,1],        //图像的尺寸(row,line)
        target:[360,360]    //显示图像的尺寸
    },
    NFT:null,           //NFT的JSON文件
    hash:null,          //用于显示NFT的Hash
    selected:null,      //选中的NFT的片段
    grid:null,          //选中的NFT的次序
    subcribe:{},        //挂载的sub的funs
}

const self={
    set:(key,value)=>{
        //console.log(key,value);
        if(map[key]===undefined) return false;
        map[key]=value;
        
        return true;
    },
    get:(key)=>{
        //console.log(map);
        if(map[key]===undefined) return false;
        return map[key];
    },
    reset:()=>{
        map.template=null;
        map.NFT=null;
        map.hash="";
        map.selected=null;
    },
};

export default self;