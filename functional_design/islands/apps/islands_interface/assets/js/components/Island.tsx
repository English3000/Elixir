import React, { useState, useEffect } from "react"
import { AppRegistry, Dimensions, PanResponder, Animated } from "react-native"
import ErrorBoundary from "./ErrorBoundary.js"
import { Undux } from "../Game"
// @ts-ignore
import Svg, { Rect } from "react-native-svg"
import merge from "lodash.merge"

export const {height, width} = Dimensions.get("window"),
             bound           = height > width ? (width-0.5) * 0.6 : (height-0.5) * 0.6,
             unit            = (multiple : number) => bound/10 * multiple

type Props = { island : {}, topLeft : number }

export default function Island({island, topLeft} : Props){
  // @ts-ignore
  const {coordinates, bounds, type}     = island,
        [onBoard, setOnBoard]           = useState(-1),
        [{pan, panResponder}, setState] = useState({pan: new Animated.ValueXY(), panResponder: {}}),
        {GameStore, GameplayStore}      = Undux.useStores(),
        player                          = GameStore.get("id")

  // NOTE: Add mobile locating -- currently islands appear immediately below board
  //        && maybe -5px flush of left edge
  // @ts-ignore
  function locate(x, y) : [number, number] {
    const marginLeft = (player === "player1") ? -3 : 11,
          row        = (topLeft + y._value + y._offset) / unit(1),
          col        = (x._value + x._offset) / unit(1) + marginLeft

    return [Math.round(row), Math.round(col)]
  }

  useEffect(() => {
    console.log("effect")
    // @ts-ignore
    const {x, y} = pan

    function onPanResponderRelease(){
      // @ts-ignore
      const {height, width}  = island.bounds,
            [row, col]       = locate(x, y),
            inBounds         = (row >= 0 && row + height <= 10 && col >= 0 && col + width <= 10) ? 1 : -1,
            same             = inBounds === onBoard,
            {count, islands} = GameplayStore.getState()

      console.log("onBoard", onBoard)
      if (!same) {
        console.log("inBounds", inBounds)
        GameplayStore.set("count")((count + inBounds))
        Promise.resolve(
          setOnBoard(inBounds)
        ).then(() => console.log("onBoard'", onBoard))
      }

      const island_ = merge({}, islands[type], {bounds: {top_left: {row, col}}})
      islands[type] = island_
      GameplayStore.set("islands")(islands)
      // @ts-ignore
      pan.flattenOffset()
    }

    // https://mindthecode.com/getting-started-with-the-panresponder-in-react-native/
    setState({pan, panResponder:
      PanResponder.create({
        onStartShouldSetPanResponder: () => true,
        // @ts-ignore
        onPanResponderGrant: () => { pan.setOffset({x: x._value, y: y._value})
                                    // @ts-ignore
                                     pan.setValue({x: 0, y: 0}) },
        onPanResponderMove: Animated.event([null, {dx: x, dy: y}]),
        onPanResponderRelease
      })
    })
  }, [])

  return (
    <ErrorBoundary>
      <Animated.View style={
        // @ts-ignore
        [{transform: pan.getTranslateTransform(), marginLeft: 5, marginBottom: 10}]} {
                     // @ts-ignore
                     ...panResponder.panHandlers}>
        <Svg width={unit(bounds.width)} height={unit(bounds.height)}>
          {coordinates.map(({col, row} : {col : number, row : number}) =>
            <Rect x={`${unit(col)}`}  width={`${unit(1)}`}
                  y={`${unit(row)}`}  height={`${unit(1)}`}
                  fill="brown"        stroke="black"
                  key={`${type}(${row},${col})`}/>)}
        </Svg>
      </Animated.View>
    </ErrorBoundary>
  )
}

AppRegistry.registerComponent("Island", () => Island)