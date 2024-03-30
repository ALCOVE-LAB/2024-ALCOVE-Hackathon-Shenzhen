let wsAPI = null;
let linking = false;
let listening=false;
const subs={};

const self = {
    link: (uri, ck) => {
        // if (linking) return setTimeout(() => {
        //     console.log(`Trying...`);
        //     self.link(uri, ck);
        // }, 500);
        // if (wsAPI !== null) return ck && ck(wsAPI);
        // //console.log(`Linking...`);
        // linking = true;
        // try {
        //     const provider = new WsProvider(uri);
        //     ApiPromise.create({ provider: provider }).then((api) => {
        //         wsAPI = api;
        //         linking = false;
        //         return ck && ck(wsAPI);
        //     });
        // } catch (error) {
        //     console.log(error);
        //     linking = false;
        //     return ck && ck(error);
        // }
        return ck && ck({error:"testing"});
    },
};

export default self;