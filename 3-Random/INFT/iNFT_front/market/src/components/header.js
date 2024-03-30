import { Row, Col } from "react-bootstrap";
import { useEffect, useState } from "react";

import {Container,Nav,Navbar,NavDropdown} from 'react-bootstrap';

function Header(props) {
    const size = {
        row: [12],
        flow:[3,6,3]
    };

    const self={

    }

    useEffect(() => {

    }, [props.update]);

    return (
        <Navbar expand="lg" className="bg-body-tertiary">
          <Container>
            <Navbar.Brand href="/home">iNFT Market</Navbar.Brand>
            <Navbar.Toggle aria-controls="basic-navbar-nav" />
            <Navbar.Collapse id="basic-navbar-nav">
              <Nav className="me-auto">
                <Nav.Link href="/home">Home</Nav.Link>
                <Nav.Link href="/template">Template</Nav.Link>
                <Nav.Link href="/minter">Minter</Nav.Link>
                <Nav.Link href="/editor">Editor</Nav.Link>
                {/* <NavDropdown title="Dropdown" id="basic-nav-dropdown">
                  <NavDropdown.Item href="#action/3.1">Action</NavDropdown.Item>
                  <NavDropdown.Item href="#action/3.2">
                    Another action
                  </NavDropdown.Item>
                  <NavDropdown.Item href="#action/3.3">Something</NavDropdown.Item>
                  <NavDropdown.Divider />
                  <NavDropdown.Item href="#action/3.4">
                    Separated link
                  </NavDropdown.Item>
                </NavDropdown> */}
              </Nav>
            </Navbar.Collapse>
          </Container>
        </Navbar>
      );
}

export default Header;