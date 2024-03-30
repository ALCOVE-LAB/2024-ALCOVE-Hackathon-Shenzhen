import { Row, Col } from "react-bootstrap";
import { useEffect, useState } from "react";

import Data from "../lib/data";

function Upload(props) {
    const size = {
        row: [12],
        upload:[7,5],
    };

    const self = {
        clickUpload:(ev)=>{

        },
        changeDef:(ev)=>{
            try {
                const fa = ev.target.files[0];
                const reader = new FileReader();
                reader.onload = (e) => {
                  try {
                    const fa = JSON.parse(e.target.result);
                    Data.set("template", fa);
                    props.fresh();
                  } catch (error) {
                    
                  }
                };
                reader.readAsText(fa);
            } catch (error) {
            
            }
        },
    }
    useEffect(() => {

    }, [props.update]);

    return (
        <Row>
            <Col className="" sm={size.row[0]} xs={size.row[0]}>
                <small>For debug, upload iNFT definition</small>
                <input className="form-control" 
                    type="file" accept="application/JSON" placeholder="The iNFT definition." onChange={(ev)=>{
                    self.changeDef(ev);
                }}/>
            </Col>
        </Row>
    )
}

export default Upload;