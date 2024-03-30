import { Row, Col, ListGroup } from "react-bootstrap";
import { useEffect, useState } from "react";

import Template from "./template";
import Hightlight from "./highlight";

//import Chain from "../lib/chain";
import Data from "../lib/data";
import Render from "../lib/render";
import tools from "../lib/tools";

import { FaBackspace,FaPuzzlePiece,FaSyncAlt,FaLongArrowAltDown,FaLongArrowAltUp } from "react-icons/fa";

let current=0;

function Detail(props) {
    const size = {
        row: [12],
        back:[9,3],
        title:[2,7,3],
        thumb:[7,5],
        hash: [10,2],
    };

    const dialog=props.dialog;
    const alink=props.alink;

    let [width, setWidth]= useState(400);
    let [height, setHeight]= useState(400);
    let [hash, setHash] = useState("0x0e70dc74951952060b5600949828445eb0acbc6d9b8dbcc396c853f8891c0486");
    let [bs64, setBS64] =useState("image/empty.png");
    let [img_part, setImagePart]=useState("");
    let [parts, setParts] =useState([]);        //iNFT的组件列表
    //let [mask, setMask]= useState(0);                   //Mask的数量

    let [hightlight, setHightlight]=useState("");
    let [owner, setOwner]=useState("");

    let [cut_width,setCutWidth]=useState(400);
    let [cut_height,setCutHeight]=useState(50);
    let [hide_mask,setHideMask]=useState(true);

    let [selected,setSelected ]=useState(0);        //选中的NFT组件
    let [active, setActive]=useState(null);         //选中的图像位次
    let [grid, setGrid]=useState([]);

    const self={
        clickBack:()=>{
            dialog(<Template fresh={props.fresh} dialog={props.dialog} />,"Template");
        },
        clickGrid:(index)=>{
            //console.log(`Index ${index} clicked.`);
            setActive(index);
        },
        clickPart:(index)=>{
            setSelected(index);
            current=index;
            self.autoFresh(index,active);
        },
        clickHashFresh:(ev)=>{
            setHash(self.randomHash(64));
            self.autoFresh(current,active);
        },
        randomHash:(n)=>{
            const str="01234567890abcdef";
            let hex="0x";
            for(let i=0;i<n;i++) hex+=str[tools.rand(0,str.length-1)];
            return hex;
        },
        getBackground:(index)=>{
            const selected_grid=Data.get("grid");
            const ac="#4aab67";
            const sc="#f7cece";
            const bc="#99ce23";
            if(selected_grid===index){
                return sc;
            }else{
                return active===index?ac:bc
            }
        },
        getHelper:(amount,line,w,h,gX,gY,eX,eY,rate)=>{       //gX没用到，默认从0开始
            const list=[];
            const max=line/(1+eX);
            const rows= Math.ceil((amount+gX)/max);
            const ww=w/rate;
            const hh=h/rate;
            for(let i=0;i<amount;i++){
                const br=Math.floor((gX+i)/max);
                list.push({
                    mX:ww*(eX+1)*((gX+i)%max),  //margin的X值
                    //mY:(br-rows)*hh*(1+eY),    //margin的Y值
                    mY:(br-rows)*hh*(1+eY)/rate,         //margin的Y值
                    wX:ww*(eX+1),            //block的width
                    wY:hh*(eY+1),            //block的height
                });
            }
            //console.log(list);
            return list;
        },
        //ipart: 选中的组件
        //iselect, 选中的零件
        autoFresh:(ipart,iselect)=>{
            const tpl = Data.getHash("cache", alink.toLocaleLowerCase());

            //console.log(tpl);
            setOwner(tpl.owner);
            
            //0.获取基本的参数
            const def=tpl.raw;
            const target=def.parts[ipart];
            const w=def.cell[0],h=def.cell[1];
            const [gX,gY,eX,eY]=target.img;
            const [start,step,divide,offset]=target.value;
            const [line,row]=def.grid;
            const max=line/(1+eX);
            const br=Math.ceil((gX+divide)/max);
            const height=h*24;      //这里的行数出错了，需要修正
            const rate=  1.0526;
            
            //1.显示hash
            setHightlight(<Hightlight start={start} step={step} hash={hash} divide={divide}/>);

            //2.截取显示对应的图像
            const ch=h*(1+eY)*br/rate;
            setCutHeight(ch);
            setCutWidth(def.size[0]);
            //console.log(ch,def);

            setHideMask(true);  //先关闭mask的显示

            const cpen=Render.create(cut_id);
            Render.clear(cut_id);
            Render.cut(cpen,def.image,w,h,gY,line,(1+eY)*br,(b64)=>{
                setImagePart(b64);
                setTimeout(()=>{
                    setHideMask(false);
                },50);
            });

            //3.显示组件列表
            setParts(def.parts);

            //4.显示组件的按钮
            const ns=self.getHelper(divide,line,w,h,gX,gY,eX,eY,rate)
            setGrid(ns);

            //5.渲染图像
            const basic = {
                cell: def.cell,
                grid: def.grid,
                target: def.size
            }
            //console.log(basic);
            const pen = Render.create(dom_id,true);
            Render.reset(pen);
            Render.preview(pen,def.image,hash,def.parts,basic);
            Render.active(pen,w*(1+eX),h*(1+eY),target.position[0],target.position[1],"#FFFFFF",2);
            setTimeout(() => {
                const img=pen.canvas.toDataURL("image/jpeg");
                setBS64(img);
            },50);  
        },
    }

    const offset=90;
    const dom_id = "pre_detail";
    const cut_id="pre_cut";
    useEffect(() => {
        setImagePart("");
        self.autoFresh(selected,active);

    }, [props.update]);

    return (
        <Row className="pt-1">
            <Col className="pt-2" sm={size.back[0]} xs={size.back[0]}>
                Alink: <strong>{props.alink}</strong> 
            </Col>
             <Col className="text-end" sm={size.back[1]} xs={size.back[1]}>
                <FaBackspace size={40} color={"#FFAABB"} onClick={(ev)=>{
                    self.clickBack(ev);
                }}/>
            </Col>
            <Col className="pt-2" sm={size.row[0]} xs={size.row[0]}></Col>
            <Col sm={size.hash[0]} xs={size.hash[0]}>
                {hightlight}
            </Col>
            <Col className="pt-4 text-end" sm={size.hash[1]} xs={size.hash[1]}>
                <FaSyncAlt size={24} color={"#FFAABB"} onClick={(ev)=>{
                    self.clickHashFresh(ev);
                }}/> 
            </Col>
            
            <Col className="pt-2" sm={size.row[0]} xs={size.row[0]}>
                <Row>
                    <Col sm={size.thumb[0]} xs={size.thumb[0]}>
                        <canvas hidden={true} id={dom_id} width={width} height={height} style={{width:"100%"}}></canvas>
                        <img src={bs64} alt="" style={{width:"100%",minHeight:"150px"}}/>
                    </Col>
                    <Col sm={size.thumb[1]} xs={size.thumb[1]}>
                        <ListGroup as="ul" style={{cursor:"pointer"}}>
                        {parts.map((row, index) => (
                            <ListGroup.Item key={index} as="li" active={selected===index} onClick={(ev)=>{
                                self.clickPart(index);
                            }}>
                                <FaPuzzlePiece size="20" color={"#AAAAAA"} style={{marginTop:"-5px"}}/>
                                <span style={{marginLeft:"15px",marginTop:"5px"}}>#{index}</span>
                            </ListGroup.Item>
                        ))}
                        </ListGroup>
                    </Col>
                </Row>
            </Col>

            <Col className="pt-2" sm={size.row[0]} xs={size.row[0]}>
                <canvas hidden={true} id={cut_id} width={cut_width} height={cut_height}></canvas>
                <img src={img_part} alt="" style={{width:"100%"}} />
                {grid.map((row, index) => (
                    <div hidden={hide_mask} className="cover" key={index} style={{
                            marginLeft:`${row.mX}px`,
                            marginTop:`${row.mY}px`,
                            width:`${row.wX}px`,
                            height:`${row.wY}px`,
                            lineHeight:`${row.wY}px`,
                            backgroundColor:self.getBackground(index),
                            color:"#FF0000",
                        }} 
                        onClick={(ev)=>{
                            self.clickGrid(index);
                        }}>
                        {index}
                    </div>
                ))}
            </Col>
            <Col className="pt-2" sm={size.row[0]} xs={size.row[0]}>
                Owner:{tools.shorten(owner,15)}
            </Col>
        </Row>
    )
}

export default Detail;