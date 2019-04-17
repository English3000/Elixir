import React, { useState, useEffect } from "react"
import { AppRegistry, StyleSheet, Platform, View } from "react-native"
import ErrorBoundary from "./ErrorBoundary"
import { Undux, styles } from "../Game"
import { unit } from "./Island"
import Tile from "./Tile"

type Coordinate = {row : number, col : number}

type Props      = {owner : string}
export default function Board({owner} : Props){
  const {GameStore, GameplayStore} = Undux.useStores(),
        attacker                   = (owner === "player1") ? "player2" : "player1",
        {id, payload}              = GameStore.getState(),
        me                         = (owner === id),
        islands                    = me ? GameplayStore.get("islands") : payload[owner].islands,
        guesses                    = payload[attacker].guesses,
        [colors, setColors]        = useState()

  useEffect(() => {
    if (payload[id].stage !== "joined") {
      const colors_ : {[coord : string]: string} = {}

      coordinates(islands || {}).forEach(({row, col} : Coordinate) =>{ colors_[`${row},${col}`] = "brown"    })
                    guesses.hits.forEach(({row, col} : Coordinate) =>{ colors_[`${row},${col}`] = "green"    })
                  guesses.misses.forEach(({row, col} : Coordinate) =>{ colors_[`${row},${col}`] = "darkblue" })

      setColors(colors_)
    }
  }, [me ? GameplayStore : null])

  return (
    <View style={custom.board}>
      <ErrorBoundary>
        {tiles(attacker, colors).map((row, i) => <View key={i} style={styles.row}>{row}</View>)}
      </ErrorBoundary>
    </View>
  )
}

const coordinates = (islands : any): Coordinate[] =>
  Object.keys(islands).reduce((acc, type) => acc.concat(islands[type].coordinates), [])

function tiles(attacker : string, colors : {[coord : string]: string}) {
  const indexes = [...Array(10).keys()]
  return (!!colors) ?
    indexes.map(row =>
      indexes.map(col => {
        const color = colors[`${row},${col}`]
        return (
          <Tile key={`tile:${row+1},${col+1}`}
                style={[custom.tile, (Platform.OS === "web") ? {cursor: (color) ? "default" : "pointer"} : {}]}
                attacker={attacker}
                color={color || "blue"}
                row={row+1}
                col={col+1} />
        )
      })
    ) :
    indexes.map(row =>
      indexes.map(col =>
        <Tile key={`tile:${row+1},${col+1}`}
              style={[custom.tile, (Platform.OS === "web") ? {cursor: "pointer"} : {}]}
              attacker={attacker}
              color="blue"
              row={row+1}
              col={col+1} />
      )
    )
}

const custom = StyleSheet.create({
  board: {marginHorizontal: unit(1), borderWidth: 0.5},
  tile:  {width: unit(1), height: unit(1), borderWidth: 0.5},
})

AppRegistry.registerComponent("Board", () => Board)