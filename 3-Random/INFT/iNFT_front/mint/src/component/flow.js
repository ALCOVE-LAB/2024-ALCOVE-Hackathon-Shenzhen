import { Row, Col } from "react-bootstrap";
import { useEffect, useState } from "react";

let font=14;

function Flow(props) {
    const size = {
        row: [12],
        flow:[3,6,3]
    };
    let [cmap,setCmap]=useState([{fontSize:font},{fontSize:font},{fontSize:font}]);
    const self={

    }

    useEffect(() => {
        // setInterval(()=>{
        //     font += 0.1;
        //     setCmap([{fontSize:font},{fontSize:font},{fontSize:font}]);
        // },100)
    }, [props.update]);

    return (
        <Row className="pt-2">
            <Col className="text-center" sm={size.flow[0]} xs={size.flow[0]}>
                <span style={cmap[0]}>280,308</span>
            </Col>
            <Col className="text-center" sm={size.flow[1]} xs={size.flow[1]}>
                <span style={cmap[1]}>280,309</span>
            </Col>
            <Col className="text-center" sm={size.flow[2]} xs={size.flow[2]}>
                <span style={cmap[2]}>280,310</span>
            </Col>
        </Row>
    )
}

export default Flow;