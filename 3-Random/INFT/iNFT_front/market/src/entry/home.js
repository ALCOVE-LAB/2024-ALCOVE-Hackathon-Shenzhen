import { Container,Row, Col } from "react-bootstrap";
import { useEffect, useState } from "react";

import Header from "../components/header";

let font=14;

function Home(props) {
    const size = {
        row: [12],
        flow:[3,6,3]
    };

    const self={

    }

    useEffect(() => {
        // setInterval(()=>{
        //     font += 0.1;
        //     setCmap([{fontSize:font},{fontSize:font},{fontSize:font}]);
        // },100)
    }, [props.update]);

    return (
        <div>
            <Header />
            <Row className="pt-2">
                <Col className="text-center" sm={size.flow[0]} xs={size.flow[0]}>
                    Home main content
                </Col>
            </Row>
        </div>
    )
}

export default Home;