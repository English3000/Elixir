import React from "react"
import { AppRegistry, StyleSheet, Platform, View } from "react-native"
import ErrorBoundary from "./ErrorBoundary";
import { Undux, styles } from "../Game"
import IslandSet from "./IslandSet"
import { unit } from "./Island"
import Tile from "./Tile"

export default function BoardRenderer(){
  const {GameStore, GameplayStore} = Undux.useStores(),
        player      = GameStore.get("id"),
        opp         = (player === "player1") ? "player2" : "player1",
        game        = GameStore.get("payload"),
        islands     = GameplayStore.get("islands"),
                      // @ts-ignore
        coordinates = (islands): object[] =>
                        Object.keys(islands)
                              .reduce((acc, type) => acc.concat(islands[type].coordinates), [])

  function tiles(owner : string){
    const attacker    = (owner === "player1") ? "player2" : "player1",
          islands_    = (owner === player) ? islands : game[owner].islands,
          coords      = islands_ ? coordinates(islands_) : [],
          guesses     = game[attacker].guesses,
          range       = (number : number): number[] =>
                          [...Array(number).keys()].map(i => i + 1)

    let colors : { [key: string]: string } = {}
                          // @ts-ignore
            coords.forEach(({row, col}) =>{ colors[`${row},${col}`] = "brown"    })
                          // @ts-ignore
      guesses.hits.forEach(({row, col}) =>{ colors[`${row},${col}`] = "green"    })
                          // @ts-ignore
    guesses.misses.forEach(({row, col}) =>{ colors[`${row},${col}`] = "darkblue" })

    return range(10).map(row =>
      range(10).map(col => {
        const color = colors[`${row},${col}`]
        return (
          <Tile key={`tile:${row},${col}`}
                style={[custom.tile, Platform.OS === "web" ? {cursor: color ? "default" : "pointer"} : {}]}
                attacker={attacker}
                color={color || "blue"}
                row={row}
                col={col} />
        )
      })
    )
  }

  const board = (attacker : string, key ?: string) =>
    <View key={key} style={{marginHorizontal: unit(1), borderWidth: 0.5}}>
      {tiles(attacker).map((row, i) => <View key={i} style={styles.row}>{row}</View>)}
    </View>

  if (Platform.OS !== "web") {
    return game[player].stage === "turn" ?
      <ErrorBoundary>
        {board(opp, "opp")}
        <View style={{paddingBottom: "10%"}} key="padding"></View>
        {board(player, "me")}
      </ErrorBoundary> :

      <ErrorBoundary>
        {board(player, "set-islands")}

        {game[player].stage === "joined" ?
          <IslandSet style={styles.row} />
        : null}
      </ErrorBoundary>
  } else { // web
    return (
      <ErrorBoundary>
        {player === "player1" ?
          <View style={styles.row}>
            {game[player].stage === "joined" ?
              <IslandSet style={[custom.web, {marginLeft: unit(-2.25)}]} />
            : null}

            {board(player)}
            {board(opp)}
          </View>
        : null}

        {player === "player2" ?
          <View style={styles.row}>
            {board(opp)}
            {board(player)}

            {game[player].stage === "joined" ?
              <IslandSet style={[custom.web, {marginLeft: unit(24)}]} />
            : null}
          </View>
        : null}
      </ErrorBoundary>
    )
  }
}

const custom = StyleSheet.create({
  board: {marginHorizontal: unit(1), borderWidth: 0.5},
  tile:  {width: unit(1), height: unit(1), borderWidth: 0.5},
  web:   {position: "absolute", zIndex: 1},
})

AppRegistry.registerComponent("BoardRenderer", () => BoardRenderer)