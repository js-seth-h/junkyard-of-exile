import React, { useRef, useEffect, useState } from "react";
import { select } from "d3";


function data(props) {


  return;
}

function Chart2() {
  // const [count, setCount] = useState(0)

  return (
    <div className="Cheart">
      <h1>Vite + React22222</h1>
      <div className="card">
        test
      </div>
    </div>
  )
}



// // // // // // // // // // 

function Chart3() {
  const [data, setData] = useState([24, 30, 45, 70, 26]);
  const svgRef = useRef(null);

  useEffect(() => {
    const svg = select(svgRef.current); // selection 객체

    svg
      .selectAll("circle")
      .data(data)
      .join(
        (enter) => enter.append("circle"),
        (update) => update.attr("class", "updated"),
        (exit) => exit.remove()
      )
      .attr("r", (value) => value)
      .attr("cx", (value) => value * 2)
      .attr("cy", (value) => value * 2)
      .attr("stroke", "red");
  }, [data]);

  return (
    <>
      <svg ref={svgRef}></svg>
      <button onClick={() => {setData(data.map(el => el + 5))}}>increase + 5</button>
      <button onClick={() => {setData(data.filter(el => el > 35))}}>filter circle r should gt 35</button>
    </>
  );
}

// // // // // // // // // // 
function Chart() {
  // const [data, setData] = useState([24, 30, 45, 70, 26]);
  const svgRef = useRef(null);

  // https://codepen.io/katzkode/pen/ZegQQB
  const data = {
    "value": 25,
    "children": 
    [
      {
        "value": 10,
        "parent": 25,
        "children": [
          {
            "value": 7,
            "parent": 10,
          },
          { 
            "value": 15,
            "parent": 10
          }
        ]
      },
      {
        "value": 50,
        "parent": 25
      }
    ]
  };

  
  useEffect(() => {
    const svg = select(svgRef.current); // selection 객체
    
    var margin = {top: 80, bottom: 80},
    width = 600,
    height = 400 - margin.top - margin.bottom;
    // select("body").append("svg")
    svg
      .selectAll("circle")
      .data(data)
      .join(
        (enter) => enter.append("circle"),
        (update) => update.attr("class", "updated"),
        (exit) => exit.remove()
      )
      
      .attr("r", (value) => value)
      .attr("cx", (value) => value * 2)
      .attr("cy", (value) => value * 2)

      // .attr("width", "100%")
      // .attr("height", "100%")//height + margin.top + margin.bottom)
      // .attr("viewBox","0 0 600 350")
      .attr("stroke", "red")
      // .append("g")
      // .attr("transform", "translate(0," + margin.top + ")");
      ;
    }, [data]);

  // useEffect(() => {
  //   const svg = select(svgRef.current); // selection 객체
  
  //   svg
  //     .selectAll("circle")
  //     .data(data)
  //     .join(
  //       (enter) => enter.append("circle"),
  //       (update) => update.attr("class", "updated"),
  //       (exit) => exit.remove()
  //     )
  //     .attr("r", (value) => value)
  //     .attr("cx", (value) => value * 2)
  //     .attr("cy", (value) => value * 2)
  //     .attr("stroke", "red");
  // }, [data]);

  return (
    <>
      <svg ref={svgRef}></svg>
      {/* <button onClick={() => {setData(data.map(el => el + 5))}}>increase + 5</button>
      <button onClick={() => {setData(data.filter(el => el > 35))}}>filter circle r should gt 35</button> */}
    </>
  );
}

export default Chart
