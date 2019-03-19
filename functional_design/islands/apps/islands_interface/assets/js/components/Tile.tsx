import React, { useState, useEffect, ComponentElement } from "react"
import { AppRegistry, TouchableOpacity } from "react-native"
import ErrorBoundary from "./ErrorBoundary.js"
import socket, { guess_coordinate } from "../socket.js"

type Props = {
  attacker ?: string,
  player   ?: string,
  isIsland  : boolean,
  style     : {},
  row       : number,
  col       : number,
}
export default function Tile(props : Props){
  const {attacker, player, isIsland, style} = props,
        [backgroundColor, setColor] = useState(isIsland ? "brown" : "blue")

  useEffect(() => {
    socket.channels[0].on("coordinate_guessed", ({player_key, row, col, hit}) => {
      if (attacker === player_key && props.row === row && props.col === col) {
        switch (hit) {
          case "hit":  setColor("green")    ; break
          case "miss": setColor("darkblue") ; break
        }
      }
    })
  }, [])

  return (
    <ErrorBoundary>
      <TouchableOpacity style={[style, {backgroundColor}]}
                        onPress={() =>
                          // @ts-ignore
                          ["blue", "brown"].includes(backgroundColor) && attacker === player ?
                            guess_coordinate(socket.channels[0], attacker, props.row, props.col) : null}/>
    </ErrorBoundary>
  )
}

AppRegistry.registerComponent("Tile", () => Tile)
