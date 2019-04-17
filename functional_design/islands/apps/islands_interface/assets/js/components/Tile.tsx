import React, { useState, useEffect } from "react"
import { AppRegistry, TouchableOpacity } from "react-native"
import ErrorBoundary from "./ErrorBoundary.js"
import socket, { guess_coordinate } from "../socket"
import { Undux } from "../Game"

type Props = {
  attacker ?: string,
  color     : string,
  row       : number,
  col       : number,
  style     : {},
}
export default function Tile(props : Props){
  const {GameStore}                 = Undux.useStores(),
        {attacker, color, style}    = props,
        player                      = GameStore.get("id"),
        game                        = GameStore.get("payload"),
        [backgroundColor, setColor] = useState(color)

  useEffect(() => {
    // @ts-ignore
    socket.channels[0].on("coordinate_guessed", ({player_key, row, col, hit}) => {
      if (attacker === player_key && props.row === row && props.col === col) {
        switch (hit) {
          case "hit":  setColor("green")    ; break
          case "miss": setColor("darkblue") ; break
        }
      }
    })
  }, [])

  useEffect(() => {if (color !== backgroundColor) setColor(color)}, [props])

  return (
    <ErrorBoundary>
      <TouchableOpacity style={[style, {backgroundColor}]}
                        onPress={() => // BUG: Not attacking
                          (game[attacker].stage === "turn") &&
                          (attacker === player) &&
                          ["blue", "brown"].includes(backgroundColor) ?
                                            // @ts-ignore
                            guess_coordinate(socket.channels[0], {player: attacker, row: props.row, col: props.col})
                          : null}
      />
    </ErrorBoundary>
  )
}

AppRegistry.registerComponent("Tile", () => Tile)
