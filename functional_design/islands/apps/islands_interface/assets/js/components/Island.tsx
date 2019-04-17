import React, { useRef, useState, useEffect } from "react"
import { AppRegistry, Dimensions, PanResponder, Animated } from "react-native"
import ErrorBoundary from "./ErrorBoundary.js"
import { Undux } from "../Game"
// @ts-ignore
import Svg, { Rect } from "react-native-svg"

export const {height, width} = Dimensions.get("window"),
             bound           = height > width ? (width-0.5) * 0.6 : (height-0.5) * 0.6,
             unit            = (multiple : number) => bound/10 * multiple

type Props = { island : {}, topLeft : number }

export default function Island({island, topLeft} : Props){
  // @ts-ignore
  const {coordinates, bounds, type}     = island,
        onBoard                         = useRef(-1),
        [{pan, panResponder}, setState] = useState({pan: new Animated.ValueXY(), panResponder: {}}),
        {GameStore, GameplayStore}      = Undux.useStores(),
        player                          = GameStore.get("id")
  // NOTE: Add mobile locating -- currently islands appear immediately below board
  //        && maybe -5px flush of left edge
  // @ts-ignore
  function locate(x, y) : {[key : string]: number} {
    const marginLeft = (player === "player1") ? -3 : 11,
          row        = (topLeft + y._value + y._offset) / unit(1),
          col        = (x._value + x._offset) / unit(1) + marginLeft

    return {row: Math.round(row), col: Math.round(col)}
  }

  useEffect(() => {
    // @ts-ignore
    const {x, y} = pan

    function onPanResponderRelease(){
      // @ts-ignore
      const {height, width}  = island.bounds,
            top_left         = locate(x, y),
            {row, col}       = top_left,
            inBounds         = (row >= 0 && row + height <= 10 && col >= 0 && col + width <= 10) ? 1 : -1,
            same             = inBounds === onBoard.current,
            {count, islands} = GameplayStore.getState()

      if (!same) {
        GameplayStore.set("count")((count + inBounds))
        onBoard.current = inBounds
      }

      islands[type] = { ...islands[type], bounds: {top_left, height, width} }
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
  }, [GameplayStore])

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