import { NFTStorage, File, Blob } from "nft.storage"


let link=null;

const self={
    init:()=>{
        link = new NFTStorage({ token: API_TOKEN });
        
    },
    read:(uri,ck)=>{

    },
    write:(json,ck)=>{

    },
}

export default self;