import { Row, Col } from "react-bootstrap";
import { useEffect, useState } from "react";

import Mine from "./mine";

import Local from "../lib/local";
import Render from "../lib/render";
import Data from "../lib/data";
import tools from "../lib/tools";
import Chain from "../lib/chain";

import { FaBackspace } from "react-icons/fa";

function Result(props) {
    const size = {
        row: [12],
        sell:[8,4],
        back:[8,4],
    };

    const anchor=props.anchor;

    let [width,setWidth]    =useState(100);
    let [height, setHeight] =useState(100);
    let [block,setBlock]= useState(0);
    
    let [block_hash,setBlockHash]=useState("");

    let [selling,setSelling]=useState(false);

    let [password, setPassword]=useState("");
    let [price, setPrice] = useState(0);
    let [info, setInfo] =useState("");
    let [name,setName]=useState("");

    const dom_id="pre_result";
    const fix=40;

    const self={
        changePrice:(ev)=>{
            setPrice(ev.target.value);
        },
        changePassword:(ev)=>{
            setPassword(ev.target.value);
        },
        clickUnSell:(ev)=>{
            if(!password) return setInfo("Please input the password");
            if(!name) return setInfo("Internal error: missing anchor name.");
            const fa = Local.get("login");
            if(fa===undefined) return setInfo("Internal error: no account to setup.");
            Chain.load(fa,password,(pair)=>{
                Chain.read(anchor,(res)=>{
                    const key = `${res.location[0]}_${res.location[1]}`;
                    const target_link=`anchor://${res.location[0]}/${res.location[1]}`;
                    const dt = res.data[key];
                    if(dt.owner!==pair.address) return setInfo("Only owner can sell the iNFT."); 
                    Chain.unsell(pair,name,(res)=>{
                        setInfo(res.message);
                        if(res.step==="Finalized"){
                            setTimeout(()=>{
                                setInfo("");
                                setSelling(false);
                                Data.removeHash("cache",target_link);
                            },400);
                        }
                    });
                });
            });
        },
        clickSell:(ev)=>{
            console.log(`Ready to selling`);
            
            if(price===0) return setInfo("Please set a price to sell");
            if(!password) return setInfo("Please input the password");
            if(!name) return setInfo("Internal error: missing anchor name.");
            const fa = Local.get("login");
            if(fa===undefined) return setInfo("Internal error: no account to setup.");
            Chain.load(fa,password,(pair)=>{
                //console.log(pair);
                Chain.read(anchor,(res)=>{
                    //console.log(res);
                    const key = `${res.location[0]}_${res.location[1]}`;
                    const target_link=`anchor://${res.location[0]}/${res.location[1]}`;
                    const dt = res.data[key];
                    if(dt.owner!==pair.address) return setInfo("Only owner can sell the iNFT.");
                    Chain.sell(pair,name,price,(res)=>{
                        setInfo(res.message);
                        if(res.step==="Finalized"){
                            setTimeout(()=>{
                                //console.log(name);
                                setInfo("");
                                setSelling(true);
                                Data.removeHash("cache",target_link);
                            },400);
                        }
                    })
                })
            });
        },
        clickHome:(ev)=>{
            props.dialog(<Mine fresh={props.fresh} dialog={props.dialog} />,"My iNFT list");
        },
        getTemplate:(alink,ck)=>{
            if (!Data.exsistHash("cache", alink)) {
                Chain.read(alink, (res) => {
                    const key = `${res.location[0]}_${res.location[1]}`;
                    const raw = JSON.parse(res.data[key].raw);
                    res.data[key].raw = raw;
                    Data.setHash("cache", alink, res.data[key]);
                    return ck && ck(res.data[key]);
                });
            } else {
                const dt=Data.getHash("cache", alink);
                return ck && ck(dt);
            }
        }
    }

    useEffect(() => {
        const fa = Local.get("login");
        if(!fa) return false;
        const login=JSON.parse(fa);
        const addr=login.address;
        //console.log(anchor);
        Chain.read(anchor,(res)=>{
            const bk=res.location[1];
            const alink=`anchor://${res.location[0]}/${res.location[1]}`;
            //console.log(res);
            const key=`${res.location[0]}_${bk}`.toLocaleLowerCase();
            const adata=res.data[key];
            const raw=JSON.parse(adata.raw);

            if(adata.sell) setSelling(true);

            setName(res.location[0]);

            Chain.hash(bk,(hash)=>{
                setBlock(bk);
                setBlockHash(hash);

                //1.保存数据
                if(!props.skip){
                    const its=Local.get("list");
                    const nlist=its===undefined?{}:JSON.parse(its);
                    if(nlist[addr]===undefined)nlist[addr]=[];
                    nlist[addr].unshift({link:alink,hash:hash});

                    Local.set("list",JSON.stringify(nlist));
                }
                
                
                //2.显示数据
                const tpl_link=raw.tpl;
                self.getTemplate(raw.tpl,(res)=>{
                    //console.log(tpl);
                    const tpl = res.raw;
                    setWidth(tpl.size[0]-fix);
                    setHeight(tpl.size[1]-fix);
                    setTimeout(() => {
                        const pen = Render.create(dom_id,true);
                        const basic = {
                            cell: tpl.cell,
                            grid: tpl.grid,
                            target: tpl.size
                        }
                        Render.clear(dom_id);
                        Render.preview(pen,tpl.image,hash,tpl.parts,basic);
                    }, 50);
                });
            });
        });
    }, [props.update,props.anchor]);

    return (
        <Row>
            <Col className="pt-2" sm={size.back[0]} xs={size.back[0]}>
                Block: {block.toLocaleString()}
            </Col>
            <Col className="pb-2 text-end" hidden={!props.back} sm={size.back[1]} xs={size.back[1]}>
                <FaBackspace size={40} color={"#FFAABB"} onClick={(ev)=>{
                    self.clickHome(ev);
                }}/>
            </Col>
            <Col className="text-center pt-2" sm={size.row[0]} xs={size.row[0]} style={{minHeight:"300px"}}>
                <canvas width={width} height={height} id={dom_id}></canvas>
            </Col>
            <Col className="pt-2" sm={size.row[0]} xs={size.row[0]}>
                Hash: {tools.shorten(block_hash,16)}
            </Col>
            <Col sm={size.row[0]} xs={size.row[0]}>
                Recommand Price: <strong>$AC 100</strong>; Rarity: <strong>0.15%</strong>
            </Col>
            <Col sm={size.row[0]} xs={size.row[0]}>
                <hr />
            </Col>
            <Col sm={size.row[0]} xs={size.row[0]}>
                <Row>
                    <Col className="pb-2" sm={size.row[0]} xs={size.row[0]}>
                        <input className="form-control" type="password" placeholder="Account password ..." onChange={(ev)=>{
                            self.changePassword(ev);
                        }}/>
                    </Col>

                    <Col hidden={selling} sm={size.sell[0]} xs={size.sell[0]}>
                        <input className="form-control" type="text" placeholder="Price to sell." 
                        value={price} 
                        onChange={(ev)=>{
                            self.changePrice(ev);
                        }}/>
                    </Col>
                    <Col hidden={selling} className="text-end" sm={size.sell[1]} xs={size.sell[1]}>
                        <button className="btn btn-md btn-primary" onClick={(ev)=>{
                            self.clickSell();
                        }}>Sell</button>
                    </Col>
                    <Col hidden={selling} className="text-end" sm={size.row[0]} xs={size.row[0]}>
                        {info}
                    </Col>

                    <Col hidden={!selling} sm={size.sell[0]} xs={size.sell[0]}>{info}</Col>
                    <Col hidden={!selling} className="text-end" sm={size.sell[1]} xs={size.sell[1]}>
                        <button className="btn btn-md btn-primary" onClick={(ev)=>{
                            self.clickUnSell();
                        }}>Revert</button>
                    </Col>
                    
                </Row>
            </Col>
            
        </Row>
    )
}

export default Result;