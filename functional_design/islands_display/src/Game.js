import React from "react"
import { StyleSheet, Text, View } from "react-native"
import {Socket} from "phoenix"
import _ from "underscore"

const socket = new Socket("/socket", {})
socket.connect()

export default class Game extends React.Component {
  constructor(props){
    super(props)
    // this.state = {}
  }

  render(){
    return (
      <View>
        {/*
        GAME: ____ [ENTER]

        <Player 1>: <phase>   <Player 2>: <phase>
        <Board>               <Board>
        <Islands> to place    <Islands> to place
        */}
      </View>
    )
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
})
