import { Row, Col } from "react-bootstrap";
import { useEffect } from "react";
import { FaList,FaRegUser,FaRegImage,FaYenSign } from "react-icons/fa";
import Account from "./account";
import Template from "./template";
import Mine from "./mine";
import Market from "./market";

function Header(props) {
    const size = {
        row: [12],
        title:[1,7,4]
    };

    const dialog=props.dialog;

    const self={
        clickMine:(ev)=>{
            dialog(<Mine fresh={props.fresh} dialog={props.dialog} />,"My iNFT list");
        },
        clickTemplate:(ev)=>{
            dialog(<Template fresh={props.fresh} dialog={props.dialog} />,"Template");
        },
        clickAccount:(ev)=>{
            dialog(<Account fresh={props.fresh} dialog={props.dialog} />,"Account Management");
        },
        clickMarket:(ev)=>{
            dialog(<Market fresh={props.fresh} dialog={props.dialog} />,"Market");
        },
    }
    useEffect(() => {
       
    }, [props.update]);

    return (
        <Row className="pt-4">
            <Col sm={size.title[0]} xs={size.title[0]}>
                <FaRegUser size={30}  onClick={(ev)=>{
                    self.clickAccount(ev);
                }}/>
            </Col>
            <Col sm={size.title[1]} xs={size.title[1]}>
               <h3 style={{marginLeft:"10px"}}>Aptos iNFT Minter</h3> 
            </Col>
            <Col className="text-end" sm={size.title[2]} xs={size.title[2]}>
                <FaYenSign size={24} onClick={(ev)=>{
                    self.clickMarket(ev);
                }}/>
                <FaRegImage size={30} style={{marginLeft:"15px"}} onClick={(ev)=>{
                    self.clickTemplate(ev);
                }}/>
                <FaList size={26} style={{marginLeft:"15px"}} onClick={(ev)=>{
                    self.clickMine(ev);
                }}/>
            </Col>
        </Row>
    )
}

export default Header;