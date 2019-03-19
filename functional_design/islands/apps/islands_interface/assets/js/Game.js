import React from "react" // `expo start` => https://blog.expo.io/announcing-expo-dev-tools-beta-c252cbeccb36
import { AppRegistry, StyleSheet, Platform, View, TextInput, Button, TouchableOpacity, Text } from "react-native"
import ErrorBoundary from "./components/ErrorBoundary.js"
import Instruction from "./components/Instruction"
import Gameplay from "./components/Gameplay.js"
import socket, { channel, history } from "./socket.js"
import queryString from "query-string"
import merge from "lodash.merge"

export const styles = StyleSheet.create({
  row: {flexDirection: "row"}
})

const custom = StyleSheet.create({
  input: {width: "50%", paddingLeft: 4, paddingBottom: 4}
})

const INITIAL_STATE = { form: {game: "", player: "", complete: false},
                        payload: null, id: null, message: null }

export default class Game extends React.Component{
  constructor(){
    super()
    this.state = history.location.search.length > 1 ? merge({}, INITIAL_STATE, {form: false}) : INITIAL_STATE
  }

  render(){
    const { form, message, payload, id } = this.state
    return (
      <ErrorBoundary>
        {form ? [
          <View key="inputs" style={[styles.row, Platform.OS !== "web" ? {marginTop: 24} : {}]}>
            <TextInput onChangeText={text => this.handleInput("game", text)}
                       placeholder="game"
                       style={custom.input}
                       value={form.game}
                       onKeyPress={event => form.complete && event.charCode === 13 ? // onEnter
                                              this.joinGame(form) : null}
                       underlineColorAndroid="black"
                       autoFocus/>

            <TextInput onChangeText={text => this.handleInput("player", text)}
                       placeholder="player"
                       style={custom.input}
                       value={form.player}
                       underlineColorAndroid="black"
                       onKeyPress={event => form.complete && event.charCode === 13 ? // onEnter
                                              this.joinGame(form) : null}/>
          </View>,

          form.complete ?
            <Button onPress={() => this.joinGame(form)}
                    title="JOIN"
                    key="button"/> : null
        ] : null}

        {message ?
          <View style={[styles.row, {justifyContent: "center"}]}>
            <Instruction message={message}
                         opponent={this.opponent()}
                         style={Platform.OS !== "web" ? {paddingTop: 6, marginLeft: -3, marginBottom: 30} : {}}/>

            {payload ?
              <TouchableOpacity key="exit" style={Platform.OS !== "web" ? {paddingTop: 24, marginLeft: -12} : {}}
                                onPress={() => { socket.channels[0].leave()
                                                 history.push("/")
                                                 this.setState(INITIAL_STATE) }}>
                <Text>EXIT</Text>
              </TouchableOpacity> : null}

            {["won", "lost"].includes(message.instruction) ?
              <TouchableOpacity key="rematch"
                                style={[{paddingLeft: 10}, Platform.OS !== "web" ? {paddingTop: 24, marginLeft: -12} : {}]}
                                onPress={() => this.joinGame({game: `rematch-${payload.game}`, player: payload[id].name})}>
                <Text>REMATCH</Text>
              </TouchableOpacity> : null}
          </View> : null}

        {(payload && id.length > 0 && message && !["won", "lost"].includes(message.instruction)) ?
          <Gameplay game={payload} player={id}/> : null}
      </ErrorBoundary>
    )
  }
  handleInput(name, value){
    const {game, player, complete} = this.state.form
    let   form

    if (name === "game") {
      form = player.length > 0 ?
        {game: value, player, complete: true} :
        {game: value, player, complete}
    } else { // name === "player"
      form = game.length > 0 ?
        {game, player: value, complete: true} :
        {game, player: value, complete}
    }

    this.setState({form})
  }
  // TODO: Add frontend channel tests
  joinGame(params){
    const {game, player} = params
    if (game.length > 0 && player.length > 0) {
      let gameChannel = channel(socket, game, player)
      gameChannel.on( "error", ({reason}) => this.setState({ message: {error: reason} }) )
      gameChannel.join()
        .receive( "ok", payload => {
          const {player1, player2} = payload
          if (player1.name === player) this.setState({ form: false, message: {instruction: player1.stage}, payload, id: "player1" })
          if (player2.name === player) this.setState({ form: false, message: {instruction: player2.stage}, payload, id: "player2" })
          history.push(`/?game=${game}&player=${player}`)
      }).receive( "error", ({reason}) => this.setState({ message: {error: reason} }) )
      gameChannel.on( "game_joined", ({player1, player2}) => {
        const {payload, id} = this.state
        this.setState({ payload: merge({}, payload, {player1: {stage: player1.stage}, player2}), message: {instruction: id === "player1" ? player1.stage : player2.stage} })
      })
      gameChannel.on( "islands_set", playerData => {
        this.setState({ payload: merge({}, this.state.payload, {[playerData.key]: playerData}), message: {instruction: playerData.stage} })
      })
      gameChannel.on( "coordinate_guessed", ({player_key}) => {
        const instruction = (player_key === this.state.id) ? "wait" : "turn"
        this.setState({ message: {instruction} })
      })
      gameChannel.on( "game_status", ({won, winner}) => {
        if (won) { const instruction = winner ? "won" : "lost"
                   this.setState({ message: {instruction} }) }
      })
      gameChannel.on( "message", ({instruction}) => this.setState({ message: {instruction} }) )
    }
  }
  opponent(){
    const {payload, id} = this.state
    if (payload) {
      const opp = (id === "player1") ? "player2" : "player1"
      return payload[opp].name
    }
  }
  // On server crash, rejoins game via query string.
  // NOTE: Page reloads in `:dev` b/c of `:phoenix_live_reload`
  componentDidMount(){
    const query = history.location.search
    if (query.length > 1) this.joinGame(queryString.parse(query))
  }
}

AppRegistry.registerComponent("Game", () => Game)
// pre-CSR, git revert 3bda5318d1d7c7a7db3ac2bb33161435633546b5