import { Row, Col } from "react-bootstrap";
import { useEffect, useState } from "react";

import Result from "./result";
import Networks from "./network";

import Local from "../lib/local";
import Render from "../lib/render";
import Chain from "../lib/chain";
import Data from "../lib/data";

import { FaAngleLeft, FaAngleRight,FaHeart,FaGripHorizontal,FaBars,FaImages } from "react-icons/fa";

function Mine(props) {
    const size = {
        row: [12],
        list: [4],
        page: [4, 4, 4],
        filter:[6,6],
        selling:[6,6],
    };

    let [list, setList] = useState([]);
    let [info, setInfo] = useState("");
    let [page_show,setPageShow]=useState(false);

    const self = {
        page: (arr, page, step) => {
            //console.log(arr);
            const nlist = [];
            const max = arr.length;
            if ((page - 1) * step > max) return nlist;
            for (let i = 0; i < step; i++) {
                const key = (page - 1) * step + i;
                if (arr[key] !== undefined) nlist.push(arr[key]);
            }
            return nlist;
        },
        cacheTemplate: (alinks, ck, dels) => {
            if (dels === undefined) dels = [];
            if (alinks.length === 0) return ck && ck(dels);
            const single = alinks.pop();
            if (!Data.exsistHash("cache", single)) {
                return Chain.read(single, (res) => {
                    const key = `${res.location[0]}_${res.location[1]}`;
                    if (res.data[key] === undefined) {
                        const left = alinks.length;
                        dels.push(left);
                        return self.cacheData(alinks, ck, dels);
                    }
                    res.data[key].raw = JSON.parse(res.data[key].raw);
                    Data.setHash("cache", single, res.data[key]);
                    return self.cacheData(alinks, ck, dels);
                });
            } else {
                return self.cacheData(alinks, ck);
            }
        },
        cacheData: (alinks, ck, tpls) => {
            if (tpls === undefined) tpls = {};
            if (alinks.length === 0) {
                const last = [];
                for (var k in tpls) last.push(k);
                return ck && ck(last);
            }
            const single = alinks.pop();
            if (!Data.exsistHash("cache", single)) {
                return Chain.read(single, (res) => {
                    const key = `${res.location[0]}_${res.location[1]}`;
                    const raw = JSON.parse(res.data[key].raw);
                    res.data[key].raw = raw;
                    if (raw.tpl) tpls[raw.tpl] = true;

                    Data.setHash("cache", single, res.data[key]);
                    return self.cacheData(alinks, ck, tpls);
                });
            } else {
                return self.cacheData(alinks, ck, tpls);
            }
        },
        getAlinks: (arr) => {
            const alist = [];
            for (let i = 0; i < arr.length; i++) {
                alist.push(arr[i].link.toLocaleLowerCase());
            }
            return alist;
        },
        getThumbs: (arr, dom_id, ck, todo) => {
            if (todo === undefined) todo = [];
            if (arr.length === 0) return ck && ck(todo);

            //1.获取数据内容
            const me = arr.shift();
            const me_anchor = Data.getHash("cache", me.link.toLocaleLowerCase());
            //console.log(me_anchor);
            const row = Data.getHash("cache", me_anchor.raw.tpl);
            const dt = row.raw;
            const basic = {
                cell: dt.cell,
                grid: dt.grid,
                target: dt.size
            }

            //2.准备绘图用的canvas
            const con = document.getElementById("handle");
            const cvs = document.createElement('canvas');
            cvs.id = dom_id;
            cvs.width = 400;
            cvs.height = 400;
            con.appendChild(cvs);

            const pen = Render.create(dom_id, true);
            Render.reset(pen);
            Render.preview(pen, dt.image, me.hash, dt.parts, basic);

            //3.获取生成的图像
            return setTimeout(() => {
                me.bs64 = pen.canvas.toDataURL("image/jpeg");
                me.block = me_anchor.block;

                me.sell=me_anchor.sell;     //附加销售的信息
                me.price=me_anchor.cost;

                //console.log(me_anchor);
                todo.push(me);
                con.innerHTML = "";

                return self.getThumbs(arr, dom_id, ck, todo);
            }, 50);
        },
        clickClean: (ev) => {
            Local.remove("list");
            props.fresh();
        },
        clickSingle: (index) => {
            //console.log(`${index} is clicked`);
            const fa = Local.get("login");
            if (!fa) return false;
            const login = JSON.parse(fa);
            const addr = login.address;

            const ls = Local.get("list");
            const my = JSON.parse(ls);
            const dt = my[addr][index];
            const alink = dt.link.toLocaleLowerCase();
            //console.log(alink);
            props.dialog(<Result anchor={alink} skip={true} back={true} dialog={props.dialog} />, "iNFT Details");
        },
    }

    const dom_id = "pre_mine";
    useEffect(() => {
        const fa = Local.get("login");
        if (fa !== undefined) {
            const login = JSON.parse(fa);
            const addr = login.address;
            const ls = Local.get("list");
            if (ls !== undefined) {
                try {
                    const nlist = JSON.parse(ls);
                    const plist = nlist[addr] === undefined ? [] : self.page(nlist[addr], 1, 10);
                    self.cacheData(self.getAlinks(plist), (tpls) => {
                        //console.log(tpls);
                        self.cacheTemplate(tpls, (dels) => {
                            //console.log(JSON.stringify(plist));
                            self.getThumbs(plist, dom_id, (glist) => {
                                //console.log(glist);
                                setPageShow(true);
                                setList(glist);
                            });
                        });
                    });
                } catch (error) {
                    console.log(error);
                }
            } else {
                setInfo("Not iNFT record.");
            }
        } else {
            setInfo("Not login yet.");
        }

    }, [props.update]);

    return (
        <Row>
            <Networks />
            <Col hidden={true} id="handle" sm={size.row[0]} xs={size.row[0]}>
                {/* <canvas hidden={true} width={400} height={400} id={dom_id}></canvas> */}
            </Col>
            <Col className="pb-2" sm={size.filter[0]} xs={size.filter[0]}>
                <FaGripHorizontal size="28"/>
                {/*切换每行显示的数量*/}
            </Col>
            <Col className="text-end pb-2" sm={size.filter[1]} xs={size.filter[1]}>
                <FaImages className="pr-2" size="24"/>
                <FaBars className="pr-2" size="24"/>
                <FaHeart size="24"/>
            </Col>
            
            <Col sm={size.row[0]} xs={size.row[0]}>{info}</Col>
            <div className="limited">
                <Col sm={size.row[0]} xs={size.row[0]}>
                    <Row>
                        {list.map((row, index) => (
                            <Col className="pt-2" key={index} sm={size.list[0]} xs={size.list[0]} onClick={(ev) => {
                                self.clickSingle(index);
                            }}>
                                <Row>
                                    <Col className="" sm={size.row[0]} xs={size.row[0]}>
                                        <img className="mine" src={row.bs64} alt="" />
                                    </Col>
                                    <Col className="" sm={size.selling[0]} xs={size.selling[0]}>
                                        {row.block.toLocaleString()}
                                    </Col>
                                    <Col className="text-end" sm={size.selling[1]} xs={size.selling[1]}>
                                        {row.sell?row.price:""}
                                    </Col>
                                </Row>
                            </Col>
                        ))}
                    </Row>
                </Col>
            </div>
            <Col hidden={!page_show} sm={size.row[0]} xs={size.row[0]}>
                <Row>
                    <Col className="pt-2" sm={size.page[0]} xs={size.page[0]}>
                        <FaAngleLeft size={36} />
                    </Col>
                    <Col className="pt-2 text-center" sm={size.page[1]} xs={size.page[1]}>
                        <h3> 3 / 10 </h3>
                    </Col>
                    <Col className="pt-2 text-end" sm={size.page[2]} xs={size.page[2]}>
                        <FaAngleRight size={36} />
                    </Col>
                </Row>
            </Col>

            <Col className="pt-4 text-end" sm={size.row[0]} xs={size.row[0]}>
                <button className="btn btn-md btn-primary" onClick={(ev) => {
                    self.clickClean(ev);
                }}>Clean</button>
            </Col>
        </Row>
    )
}

export default Mine;