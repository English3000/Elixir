import React from "react"
import { AppRegistry, Platform, StyleSheet, TouchableOpacity, View } from "react-native"
import { styles } from "../Game.js"
import ErrorBoundary from "./ErrorBoundary.js"
import Tile from "./Tile"
import { unit } from "./Island.js"
import _ from "underscore"

export default class Board extends React.Component{
  constructor(props){
    super(props)

    const cursor = props.game[props.attacker].islands ? "pointer" : "default"
    this.state = { board: _.map(_.range(10), row =>
                            _.map( _.range(10), col =>
                              <Tile key={`tile${row},${col}`}
                                    style={[custom.tile, Platform.OS === "web" ? {cursor} : {}]}
                                    row={row}
                                    col={col}
                                    attacker={props.attacker}
                                    player={props.player}
                                    isIsland={false}/> )) }
  }

  render(){ return <ErrorBoundary>
                     <View style={{marginHorizontal: unit(1), borderWidth: 0.5}}>
                       {_.map( this.state.board, (row, i) =>
                         <View key={i} style={styles.row}>{row}</View> )}
                     </View>
                   </ErrorBoundary> }

  componentDidMount(){ this.renderBoard() }

  componentDidUpdate(prevProps){
    const owner = (this.props.attacker === "player1") ? "player2" : "player1"

    if (prevProps.game[owner].stage === "joined") this.renderBoard()
  }

  renderBoard(){
    const {game, attacker, player} = this.props,
          owner = (attacker === "player1") ? game["player2"] : game["player1"]

    if (owner.stage !== "joined") {
      const {board} = this.state,
            enemy = game[attacker]

      if (owner.islands) {
        _.each(Object.values(owner.islands), island =>
          _.each( island.coordinates, coord =>
            board[coord.row][coord.col] =
              <Tile key={`island${coord.row},${coord.col}`}
                    style={[custom.tile, Platform.OS === "web" ? {cursor: "default"} : {}]}
                    row={coord.row}
                    col={coord.col}
                    attacker={attacker}
                    player={player}
                    isIsland={true}/> ))
      }
      _.each( enemy.guesses.hits, coord =>
        board[coord.row][coord.col] =
          <ErrorBoundary key={`hit${coord.row},${coord.col}`}>
            <TouchableOpacity style={[custom.tile, {backgroundColor: "green"}, Platform.OS === "web" ? {cursor: "default"} : {}]}/>
          </ErrorBoundary>
      )
      _.each( enemy.guesses.misses, coord =>
        board[coord.row][coord.col] =
          <ErrorBoundary key={`miss${coord.row},${coord.col}`}>
            <TouchableOpacity style={[custom.tile, {backgroundColor: "darkblue"}, Platform.OS === "web" ? {cursor: "default"} : {}]}/>
          </ErrorBoundary>
      )
      this.setState({board})
    }
  }
}

const custom = StyleSheet.create({
  tile: {width: unit(1), height: unit(1), borderWidth: 0.5}
})

AppRegistry.registerComponent("Board", () => Board)
