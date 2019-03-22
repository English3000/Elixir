import React, { Component } from "react"
import { AppRegistry, Dimensions, PanResponder, Animated } from "react-native"
import ErrorBoundary from "./ErrorBoundary.js"
// @ts-ignore
import Svg, { Rect } from "react-native-svg"

export const {height, width} = Dimensions.get("window"),
             bound           = height > width ? (width-0.5) * 0.6 : (height-0.5) * 0.6,
             unit            = (multiple : number) => bound/10 * multiple

type Props = { count : number, island : {}, topLeft : number, GameStore : any, GameplayStore : any }
type State = { onBoard : number, pan : {} }

export default class Island extends Component<Props, State> {
  // @ts-ignore
  constructor(props) {
    super(props)
    this.state = { pan: new Animated.ValueXY(), onBoard: -1 }
    // @ts-ignore
    this.panResponder = {}
    this.locate = this.locate.bind(this)
  }
  render(){
    // @ts-ignore
    const {coordinates, bounds, type} = this.props.island
    return (
      <ErrorBoundary>
        <Animated.View style={
          // @ts-ignore
          [{transform: this.state.pan.getTranslateTransform(), marginLeft: 5, marginBottom: 10}]} {
                       // @ts-ignore
                       ...this.panResponder.panHandlers}>
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

  componentDidMount(){
    const {GameStore, GameplayStore, count, island} = this.props,
          // @ts-ignore
          {x, y}                                    = this.state.pan,
          onPanResponderRelease                     = () => {
      // @ts-ignore
      const {height, width} = island.bounds,
            [row, col]      = this.locate(x, y, GameStore.get("id")),
            onBoard         = (row >= 0 && row + height <= 10 && col >= 0 && col + width <= 10) ? 1 : -1

      // NOTE: Same issue for `count` as w/ Hooks.
      if (onBoard !== this.state.onBoard) {
        console.log("onBoard", this.state.onBoard)
        console.log("setState", onBoard)
        GameplayStore.set("count")(count + onBoard)
        Promise.resolve(
          this.setState({onBoard})
        ).then(() => console.log("onBoard'", this.state.onBoard))
      }
      // @ts-ignore
      this.state.pan.flattenOffset()
    }
    // @ts-ignore
    this.panResponder = PanResponder.create({
      onStartShouldSetPanResponder: () => true,
      // via: https://mindthecode.com/getting-started-with-the-panresponder-in-react-native/
      // @ts-ignore
      onPanResponderGrant: () => { this.state.pan.setOffset({x: x._value, y: y._value})
      // @ts-ignore
                                   this.state.pan.setValue({x: 0, y: 0}) },
      onPanResponderMove: Animated.event([null, {dx: x, dy: y}]),
      onPanResponderRelease
    })
    this.forceUpdate()
  }
  // @ts-ignore
  locate(x, y, player : string) : [number, number] {
    const marginLeft = (player === "player1") ? -3 : 11,
          row        = (this.props.topLeft + y._value + y._offset) / unit(1),
          col        = (x._value + x._offset) / unit(1) + marginLeft

    return [Math.round(row), Math.round(col)]
  }
}

AppRegistry.registerComponent("Island", () => Island)