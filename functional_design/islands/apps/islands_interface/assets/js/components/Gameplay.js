import React from "react"
import { AppRegistry, StyleSheet, Platform, View, TouchableOpacity, Text } from "react-native"
import ErrorBoundary from "./ErrorBoundary.js"
import Board from "./Board.js"
import Island, { unit, bound } from "./Island.js"
import { styles } from "../Game.js"
import socket, { set_islands } from "../socket.js"
import merge from "lodash.merge"
import _ from "underscore"

const custom = StyleSheet.create({
  web: {position: "absolute", zIndex: 1},

  button: { width: bound,
            backgroundColor: "limegreen",
            marginTop: 18,
            borderRadius: 15,
            padding: 5,
            paddingBottom: 6.5 },

  buttonText: {textAlign: "center", fontSize: 16.5, fontStyle: "italic"}
})

export default class Gameplay extends React.Component{
  constructor(props){
    super(props)
    this.renderBoards = this.renderBoards.bind(this)
    this.updateIslands = this.updateIslands.bind(this)
    this.state = merge({onBoard: 0}, props.game[props.player].islands)
  }

  render(){
    const {game, player} = this.props
    return <ErrorBoundary>
             <View key="display"
                   style={{alignItems: "center"}}>
               {this.renderBoards(this.props)}

               {this.state.onBoard === 5 && game[player].stage === "joined" ?
                 <TouchableOpacity style={custom.button}
                                   onPress={() => set_islands(socket.channels[0], {player, islands: this.state})}>
                   <Text style={custom.buttonText}>SET ISLANDS</Text>
                 </TouchableOpacity> : null}
             </View>
           </ErrorBoundary>
  }

  renderBoards({game, player}){
    const opp = (player === "player1") ? "player2" : "player1",
          my = game[player]

    if (Platform.OS !== "web") {
      return my.stage === "turn" ?
             [ <Board game={game} attacker={player} player={player} key="opp"/> ,
               <View style={{paddingBottom: "10%"}} key="padding"></View> ,
               <Board game={game} attacker={opp}    player={player} key="me"/> ] :

             [ <Board game={game} attacker={opp} player={player} key="set-islands"/> ,
               my.stage === "joined" ?
                 this.renderIslandSet(styles.row) : null ]
    } else { // web
      return [
        (player === "player1") ?
          <View key="me" style={styles.row}>
            {my.stage === "joined" ?
              this.renderIslandSet([custom.web, {marginLeft: unit(-2.25)}]) : null}
            <Board game={game} attacker={opp}    player={player}/>
            <Board game={game} attacker={player} player={player}/>
          </View> : null,

        (player === "player2") ?
          <View key="me" style={styles.row}>
            <Board game={game} attacker={player} player={player}/>
            <Board game={game} attacker={opp}    player={player}/>
            {my.stage === "joined" ?
              this.renderIslandSet([custom.web, {marginLeft: unit(24)}]) : null}
          </View> : null ]
    }
  }

  renderIslandSet(style = {}){
    let topLeft = 0

    return <ErrorBoundary key="unset-islands">
             <View style={style}>
               {_.map( _.pairs(this.state), ([type, island]) => {
                 if (type === "onBoard") return null

                 let height = unit(island.bounds.height) + 10  // marginBottom
                 topLeft += height

                 return <Island key={type}
                                island={island}
                                player={this.props.player}
                                topLeft={topLeft - height}
                                updateIslands={this.updateIslands}/> })}
             </View>
           </ErrorBoundary>
  }

  updateIslands(type, top_left, onBoard){
    let island = merge({}, this.state[type], {bounds: {top_left}})
    this.setState({[type]: island, onBoard: this.state.onBoard + onBoard})
  }
}

AppRegistry.registerComponent("Gameplay", () => Gameplay)
