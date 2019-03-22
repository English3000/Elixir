import React, { useEffect } from "react"
import { AppRegistry, StyleSheet, View, TouchableOpacity, Text } from "react-native"
import ErrorBoundary from "./ErrorBoundary.js"
import socket, { set_islands } from "../socket"
import { Undux } from "../Game"
import BoardRenderer from "./BoardRenderer"
import { bound } from "./Island"

export type GameplayState = { count : number, islands ?: {} }
export const GameplayState : GameplayState = {count: 0, islands: undefined}
export default function Gameplay(){
  const {GameStore, GameplayStore} = Undux.useStores(),
        player                     = GameStore.get("id"),
        my                         = GameStore.get("payload")[player],
        islands                    = GameplayStore.get("islands")

  useEffect(() => { GameplayStore.set("islands")(my.islands) }, [])

  return (
    <ErrorBoundary>
      <View key="display" style={{alignItems: "center"}}>
        {islands ? <BoardRenderer /> : null}

        {GameplayStore.get("count") === 5 && my.stage === "joined" ?
          <TouchableOpacity style={custom.button}
                            onPress={() =>
                              // @ts-ignore
                              set_islands(socket.channels[0], {player, islands})}>
            <Text style={custom.buttonText}>SET ISLANDS</Text>
          </TouchableOpacity>
        : null}
      </View>
    </ErrorBoundary>
  )
}

const custom = StyleSheet.create({
  button: { width: bound,
            backgroundColor: "limegreen",
            marginTop: 18,
            borderRadius: 15,
            padding: 5,
            paddingBottom: 6.5 },

  buttonText: {textAlign: "center", fontSize: 16.5, fontStyle: "italic"}
})

AppRegistry.registerComponent("Gameplay", () => Gameplay)