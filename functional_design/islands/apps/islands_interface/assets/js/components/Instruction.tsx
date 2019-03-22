import React from "react"
import { AppRegistry, StyleSheet, Platform, Text } from "react-native"
import ErrorBoundary from "./ErrorBoundary.js"
// coupled to IslandsEngine.Game.Stage atoms
function renderInstruction(instruction : string, opponent : string){
  switch (instruction) {
    case "joined":
      return "Drag your islands onto the board!"
    case "left":
      return `Opponent ${opponent} left game.`
    case "ready":
      return "Waiting for other player to set islands."
    case "turn":
      return "YOUR TURN: Click on a square to attack."
    case "wait":
      return "Your opponent is attacking..."
    case "won":
      return "Congrats! You've WON."
    case "lost":
      return "Your opponent has won... Better luck next game!"
    default:
      return instruction
  }
}

type Message = { error ?: string, instruction ?: string }
type Props   = { message : Message, opponent : string, style : object }
export default function Instruction({message, opponent, style} : Props){
  return (
    <ErrorBoundary>
      <Text style={[custom.instruction, style]}>
        {message.error ?
          `ERROR: ${message.error.replace(/_/, " ")}.`
        : renderInstruction(message.instruction, opponent)}
      </Text>
    </ErrorBoundary>
  )
}

const custom = StyleSheet.create({
  instruction: {textAlign: "center", fontSize: (Platform.OS === "web") ? 24 : 18, margin: 18}
})

AppRegistry.registerComponent("Instruction", () => Instruction)