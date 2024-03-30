const anchorJS = window.AnchorJS;
const easyRun = window.Easy.easyRun;
const { ApiPromise, WsProvider } = window.Polkadot;

let wsAPI = null;
let linking = false;
let listening=false;
const subs={};

const self = {
    link: (uri, ck) => {
        if (linking) return setTimeout(() => {
            console.log(`Trying...`);
            self.link(uri, ck);
        }, 500);
        if (wsAPI !== null) return ck && ck(wsAPI);
        //console.log(`Linking...`);
        linking = true;
        try {
            const provider = new WsProvider(uri);
            ApiPromise.create({ provider: provider }).then((api) => {
                wsAPI = api;
                linking = false;
                return ck && ck(wsAPI);
            });
        } catch (error) {
            console.log(error);
            linking = false;
            return ck && ck(error);
        }
    },
    read: (alink, ck) => {
        anchorJS.set(wsAPI);
        const startAPI = {
            common: {
                "latest": anchorJS.latest,
                "target": anchorJS.target,
                "history": anchorJS.history,
                "owner": anchorJS.owner,
                "subcribe": anchorJS.subcribe,
                "multi": anchorJS.multi,
                "block": anchorJS.block,
            },
            agent: {
                "process": (txt) => {
                    console.log(txt);
                },
            },
        };
        easyRun(alink.toLocaleLowerCase(), startAPI, (res) => {
            return ck && ck(res);
        });
    },
    write:(pair,anchor,ck)=>{
        const {name,raw,protocol}=anchor;
        anchorJS.write(pair,name,raw,protocol,(res)=>{
            return ck && ck(res);
        });
    },
    subscribe:(key,fun)=>{
        if(listening===false){
            anchorJS.subcribe((anchors,block,hash)=>{
                for(let k in subs){
                  subs[k](block,hash);
                }
            });
            listening=true;
        }
        subs[key]=fun;
    },
    load:(fa,password,ck)=>{
        const {Keyring}=window.Polkadot;
        try {
            const acc=JSON.parse(fa);
            const keyring = new Keyring({ type: "sr25519" });
            const pair = keyring.createFromJson(acc);
            try {
                pair.decodePkcs8(password);
                return  ck && ck(pair);
            } catch (error) {
                return ck && ck({error:"Invalid passoword"});
            }
        } catch (error) {
            return ck && ck({error:"Invalid file"}); 
        }
    },
    search:(name,ck)=>{
        return anchorJS.search(name,ck);
    },
    balance:(address,ck)=>{
        return anchorJS.balance(address,ck);
    },
    hash:(block,ck)=>{
        return anchorJS.hash(block,ck);
    },
    sell:(pair,anchor,price,ck,target)=>{
        return anchorJS.sell(pair,anchor,price,ck,target);
    },
    unsell:(pair,anchor,ck)=>{
        return anchorJS.unsell(pair,anchor,ck);
    }
};

export default self;