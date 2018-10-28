import React from "react"
import { AppRegistry, TouchableOpacity } from "react-native"
import ErrorBoundary from "./ErrorBoundary.js"
import socket, { guess_coordinate } from "../socket.js"

export default class Tile extends React.Component{
  constructor(props){
    super(props)
    this.state = {backgroundColor: props.isIsland ? "brown" : "blue", isTurn: props.isTurn}
  }

  render(){
    const {attacker, player, row, col, isIsland, style} = this.props,
          {backgroundColor} = this.state
    return <ErrorBoundary>
             <TouchableOpacity style={[style, {backgroundColor}]}
                               onPress={() =>
                                 ["blue", "brown"].includes(backgroundColor) && attacker === player ?
                                   guess_coordinate(socket.channels[0], attacker, row, col) : null}/>
           </ErrorBoundary>
  }

  componentDidMount(){
    const {attacker, player} = this.props
    socket.channels[0].on("coordinate_guessed", ({player_key, row, col, hit}) => {
      if (attacker === player_key && this.props.row === row && this.props.col === col) {
        switch (hit) {
          case "hit":  return this.setState({backgroundColor: "green"})
          case "miss": return this.setState({backgroundColor: "darkblue"})
        }
      }
    })
  }
}

AppRegistry.registerComponent("Tile", () => Tile)
