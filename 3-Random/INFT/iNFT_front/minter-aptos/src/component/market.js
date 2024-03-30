import { Row, Col } from "react-bootstrap";
import { useEffect, useState } from "react";

function Market(props) {
    const size = {
        row: [12],
    };

    let [list, setList]=useState([]);

    const self={

    }
    useEffect(() => {
       
    }, [props.update]);

    return (
        <Row className="pt-4">
            <Col sm={size.row[0]} xs={size.row[0]}>
                
            </Col>
        </Row>
    )
}

export default Market;