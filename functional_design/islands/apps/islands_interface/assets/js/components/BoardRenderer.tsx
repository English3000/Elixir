import React from "react"
import { AppRegistry, StyleSheet, Platform, View } from "react-native"
import ErrorBoundary from "./ErrorBoundary"
import { Undux, styles } from "../Game"
import Board from "./Board"
import IslandSet from "./IslandSet"
import { unit } from "./Island"

export default function BoardRenderer(){
  const {id, payload} = Undux.useStores().GameStore.getState(),
        stage         = payload[id].stage,
        oppId         = (id === "player1") ? "player2" : "player1"

  if (Platform.OS !== "web") {
    return stage === "turn" ?
      <ErrorBoundary>
        <Board key="opp" owner={oppId} />
        <View  key="padding" style={{paddingBottom: "10%"}} />
        <Board key="me"  owner={id}    />
      </ErrorBoundary> :

      <ErrorBoundary>
        <Board key="set-islands" owner={id} />

        {stage === "joined" ?
          <IslandSet style={styles.row} />
        : null}
      </ErrorBoundary>
  } else { // web
    return (
      <ErrorBoundary>
        {id === "player1" ?
          <View style={styles.row}>
            {stage === "joined" ?
              <IslandSet style={[custom.web, {marginLeft: unit(-2.25)}]} />
            : null}

            <Board owner={id}    />
            <Board owner={oppId} />
          </View>
        : null}

        {id === "player2" ?
          <View style={styles.row}>
            <Board owner={oppId} />
            <Board owner={id}    />

            {stage === "joined" ?
              <IslandSet style={[custom.web, {marginLeft: unit(24)}]} />
            : null}
          </View>
        : null}
      </ErrorBoundary>
    )
  }
}

const custom = StyleSheet.create({
  web:   {position: "absolute", zIndex: 1},
})

AppRegistry.registerComponent("BoardRenderer", () => BoardRenderer)