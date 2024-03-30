import { Row, Col } from "react-bootstrap";
import { useEffect, useState } from "react";

import Flow from "./flow";

import Data from "../lib/data";
import Render from "../lib/render";
import tools from "../lib/tools";
import Local from "../lib/local";
import Chain from "../lib/chain";

function Preview(props) {
    const size = {
        row: [12],
    };

    let [width, setWidth] = useState(100);
    let [height, setHeight] = useState(100);
    let [block, setBlock] = useState(0);
    let [hash, setHash] = useState("0x0e70dc74951952060b5600949828445eb0acbc6d9b8dbcc396c853f8891c0486");
    let [alink, setAlink] = useState("");

    const self = {
        
    }

    const dom_id = "previewer";
    useEffect(() => {
        const tpl = Data.get("template");
        if (tpl !== null) {
            setWidth(tpl.size[0]);
            setHeight(tpl.size[1]);
            setTimeout(() => {
                const pen = Render.create(dom_id);
                const basic = {
                    cell: tpl.cell,
                    grid: tpl.grid,
                    target: tpl.size
                }
                Chain.subscribe("preview", (bk, bhash) => {
                    setBlock(bk);
                    setHash(bhash);
                    const style={font:"13px serif",color:"#000000"}
                    Render.clear(dom_id);
                    Render.text(pen,bhash,[0,24],style);
                    Render.text(pen,bk,[10,380],style);
                    Render.text(pen,alink,[100,380],style);
                    Render.text(pen,props.node,[280,380],style);
                    Render.preview(pen,tpl.image,bhash,tpl.parts,basic);
                });
            }, 50);
        }

        const tpls = Local.get("template");
        if (tpls !== undefined) {
            const list = JSON.parse(tpls);
            const tpl = list[0];
            setAlink(tpl.alink);
        }
    }, [props.update]);

    return (
        <Row className="pt-2">
            {/* <Col className="pt-4" sm={size.row[0]} xs={size.row[0]}>
                Block {block.toLocaleString()}: {tools.shorten(hash, 12)}
            </Col> */}
            <Col className="text-center pt-2" sm={size.row[0]} xs={size.row[0]}>
                <canvas width={width} height={height} id={dom_id}></canvas>
            </Col>
            
            {/* <Col className="" sm={size.row[0]} xs={size.row[0]}>
                Current Template: <strong>{alink}</strong><br/>
                Current Network URL: <strong>{props.node}</strong>
            </Col> */}
            <Flow />
            <Col className="" sm={size.row[0]} xs={size.row[0]}>
                <br/>The iNFT created from the block hash when mint, click the button to try.
            </Col>
        </Row>
    )
}

export default Preview;