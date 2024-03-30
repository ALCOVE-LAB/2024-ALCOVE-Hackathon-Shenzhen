import { Container, Col, Row } from "react-bootstrap";
import { useEffect, useState } from "react";

import { BrowserRouter, Routes, Route } from "react-router-dom";

import Home from "./entry/home";
import Template from "./entry/template";
import Editor from "./entry/editor";
import Minter from "./entry/minter";
import Mine from "./entry/mine";
import View from "./entry/view";

function App() {

  const size = {
    row: [12],
  };


  const self = {

  }

  return (
    <BrowserRouter>
      <Routes>
          <Route path="home" index element={<Home />} />
          <Route path="template" element={<Template />} />
          <Route path="editor" element={<Editor />} />
          <Route path="minter" element={<Minter />} />
          <Route path="/" element={<Mine />}></Route>
          <Route path="*" element={<View />}></Route>
      </Routes>
    </BrowserRouter>
  );
}

export default App;
