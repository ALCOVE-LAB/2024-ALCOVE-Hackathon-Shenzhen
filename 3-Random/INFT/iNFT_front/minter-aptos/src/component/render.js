import { Row, Col } from "react-bootstrap";
import { useEffect, useState } from "react";

import Data from "../lib/data";
import Render from "../lib/render";
import tools from "../lib/tools";
import Local from "../lib/local";
import Chain from "../network/aptos";

import { Network } from "@aptos-labs/ts-sdk";

let internal_fresh = null;

function Preview(props) {
    const size = {
        row: [12],
    };

    let [width, setWidth] = useState(100);
    let [height, setHeight] = useState(100);
    let [block, setBlock] = useState(0);
    let [hash, setHash] = useState("0x0000000000000000000000000000000000000000000000000000000000000000");
    let [alink, setAlink] = useState("");

    const self = {
        autoCheck:()=>{
            const tpl = Data.get("template");
            //console.log(tpl);
            if(tpl===null) return setTimeout(()=>{
                self.autoCheck();
            },2000);
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
    
                    Chain.subscribe((res) => {
                        let bk = res.block_height;
                        Chain.view(bk, "block", (res) => {
                            const bhash = res.block_hash;
                            setBlock(bk);
                            setHash(bhash);
                            Render.preview(pen, tpl.image, bhash, tpl.parts, basic);
                        }, Network.DEVNET);
                    }, Network.DEVNET);
                }, 50);
            }
    
            const tpls = Local.get("template");
            if (tpls !== undefined) {
                const list = JSON.parse(tpls);
                const tpl = list[0];
                setAlink(tpl.alink);
            }
        },
    }

    const dom_id = "previewer";
    useEffect(() => {
        self.autoCheck();
    }, [props.update]);

    return (
        <Row className="pt-2">
            <Col sm={size.row[0]} xs={size.row[0]}>
                Aptos block {block.toLocaleString()}: {tools.shorten(hash, 20)}
            </Col>
            <Col className="text-center pt-2" sm={size.row[0]} xs={size.row[0]}>
                <canvas width={width} height={height} id={dom_id}></canvas>
            </Col>
            <Col className="" sm={size.row[0]} xs={size.row[0]}>
                <br />The iNFT created from the block hash when mint, click the button to try.
            </Col>
        </Row>
    )
}

export default Preview;