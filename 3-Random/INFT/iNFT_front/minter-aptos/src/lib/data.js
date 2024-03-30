const map={
    template:null,      //当前模版image文件
    cache:{             //缓存的模版文件

    }
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

    setHash:(main,key,value)=>{
        if(map[main]===undefined) return false;
        map[main][key]=value;
        return true;
    },
    getHash:(main,key)=>{
        if(map[main]===undefined) return false;
        if(map[main][key]===undefined) return false;
        return map[main][key]
    },
    exsistHash:(main,key)=>{
        if(map[main]===undefined) return false;
        if(map[main][key]===undefined) return false;
        return true;
    },
    removeHash:(main,key)=>{
        if(map[main]===undefined) return false;
        if(map[main][key]===undefined) return false;
        delete map[main][key];
        return true;
    },
};

export default self;