import React, { useRef, useEffect } from "react"
// @ts-ignore
import { createConnectedStoreAs, Store, withLogger, withReduxDevtools } from "undux"
import { AppRegistry, StyleSheet, Platform, View, TextInput, Button, TouchableOpacity, Text } from "react-native"
import ErrorBoundary from "./components/ErrorBoundary.js"
import Instruction from "./components/Instruction"
import Gameplay, { GameplayState } from "./components/Gameplay"
// let Gameplay : (props : Undux) => JSX.Element, {GameplayState} = require("Gameplay.tsx");
import socket, { channel, history } from "./socket"
// @ts-ignore
import queryString from "query-string"

type Form = {
  complete : boolean,
  game     : string,
  player   : string,
}
type GameState = {
  form     : Form | false,
  id      ?: string,
  message ?: string,
  payload ?: {},
  update   : boolean,
}
type AllStates = {
  GameStore:     GameState,
  GameplayStore: GameplayState,
}
export type Undux = Store<AllStates>

const INITIAL_STATE         = {complete: false, game: "", player: ""},
      Form                  = history.location.search.length > 1 ? false : INITIAL_STATE,
      GameState : GameState = {form: Form, update: true, id: undefined, message: undefined, payload: undefined},
      DevTools              = process.env.NODE_ENV === "production" ? undefined : [withLogger, withReduxDevtools]

function setupDevTool(stores : Undux){
  for (const key in stores) DevTools.forEach(Tool => Tool(stores[key]))
}

export const Undux     = createConnectedStoreAs({
                           GameStore:     GameState,
                           GameplayStore: GameplayState,
                         }, setupDevTool)

export default function Game(){
  const {GameStore, GameplayStore}   = Undux.useStores(),
        {form, id, message, payload} = GameStore.getState(),
        {game, player, complete}     = form,
        payloadValue                 = useRef(payload)

  function opponent() : string | undefined {
    if (payload)
      return payload[
        (id === "player1") ? "player2" : "player1"
      ].name
  }

  function handleInput(name : string, value : string){
    let form_
    if (name === "game") {
      form_ = (player.length > 0) ?
                {game: value, player, complete: true} :
                {game: value, player, complete}
    } else { // name === "player"
      form_ = (game.length > 0) ?
                {game, player: value, complete: true} :
                {game, player: value, complete}
    }

    GameStore.set("form")(form_)
  }

  function joinGame({complete, game, player} : Form, charCode = 13 /* enter */){
    if (complete !== false && charCode === 13 && game.length > 0 && player.length > 0) {
      let gameChannel = channel(socket, game, player)
      gameChannel.on( "error", ({reason}) => GameStore.set("message")({error: reason}) )
      gameChannel.join()
        .receive( "ok", payload_ => {
          const id_ = (payload_.player1.name === player) ? "player1" : "player2"
          GameStore.on("payload").subscribe((payload_ : any) => {
            payloadValue.current = payload_
            GameplayStore.set("islands")(payload_[id_].islands)
          })
          GameStore.set("form")(false)
          GameStore.set("id")(id_)
          GameStore.set("payload")(payload_)
          GameStore.set("message")({instruction: payload_[id_].stage})
          history.push(`/?game=${game}&player=${player}`)
      }).receive( "error", ({reason}) => GameStore.set("message")({error: reason}) )
      gameChannel.on( "islands_set", playerData => {
        GameStore.set("message")({instruction: playerData.stage})
        payloadValue.current[playerData.key] = playerData
        GameStore.set("payload")(payloadValue.current)
      })
      gameChannel.on( "coordinate_guessed", ({player_key}) =>
        GameStore.set("message")({
          instruction: (player_key === id) ? "wait" : "turn"
        })
      )
      gameChannel.on( "game_status", ({won, winner}) => {
        if (won) GameStore.set("message")({
          instruction: winner ? "won" : "lost"
        })
      })
      gameChannel.on( "message", ({instruction}) => GameStore.set("message")({instruction}) )
    }
  }
  // NOTE: Disabled `:phoenix_live_reload` so page doesn't auto-reload
  /** On server crash, rejoins game via query string. */
  useEffect(() => {
    if (GameStore.get("update")) { // TODO: check if another scoping bug
      GameStore.set("update")(false)
      const query = history.location.search
      if (query.length > 1) joinGame(queryString.parse(query))
    }
  })

  return (
    <ErrorBoundary>
      {form ? [
        <View key="inputs" style={[styles.row, Platform.OS !== "web" ? {marginTop: 24} : {}]}>
          <TextInput onChangeText={text => handleInput("game", text)}
                     placeholder="game"
                     style={custom.input}
                     value={form.game}
                     onKeyPress={({charCode}) => joinGame(form, charCode)}
                     underlineColorAndroid="black"
                     autoFocus />

          <TextInput onChangeText={text => handleInput("player", text)}
                     placeholder="player"
                     style={custom.input}
                     value={form.player}
                     underlineColorAndroid="black"
                     onKeyPress={({charCode}) => joinGame(form, charCode)} />
        </View>,

        form.complete ?
          <Button key="button" title="JOIN" onPress={() => joinGame(form)} />
        : null
      ] : null}

      {message ?
        <View style={[styles.row, {justifyContent: "center"}]}>
          <Instruction message={message}
                       opponent={opponent()}
                       style={Platform.OS !== "web" ? {paddingTop: 6, marginLeft: -3, marginBottom: 30} : {}} />

          {payload ?
            <TouchableOpacity key="exit"
                              onPress={() => {
                                        // @ts-ignore
                                        socket.channels[0].leave()
                                        history.push("/")
                                        GameStore.set("form")(INITIAL_STATE) }}
                              style={(Platform.OS !== "web") ? {paddingTop: 24, marginLeft: -12} : {}}>
              <Text>EXIT</Text>
            </TouchableOpacity>
          : null}

          {["won", "lost"].includes(message.instruction) ?
            <TouchableOpacity key="rematch"
                              style={[ {paddingLeft: 10}, (Platform.OS !== "web") ? {paddingTop: 24, marginLeft: -12} : {} ]}
                              onPress={() => joinGame({complete: true, game: `rematch-${payload.game}`, player: payload[id].name})}>
              <Text>REMATCH</Text>
            </TouchableOpacity>
          : null}
        </View>
      : null}

      {payload && id && message && !["won", "lost"].includes(message.instruction) ?
        <Gameplay />
      : null}
    </ErrorBoundary>
  ) // BUG: All display on exit (so `payload` cond. isn't working now...)
}

const custom = StyleSheet.create({
  input: {width: "50%", paddingLeft: 4, paddingBottom: 4}
})

export const styles = StyleSheet.create({
  row: {flexDirection: "row"}
})

AppRegistry.registerComponent("Game", () => Game)