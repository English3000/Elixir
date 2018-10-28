import { Socket } from "phoenix"
import createHistory from "history/createMemoryHistory"
import { Platform } from "react-native"

export const history = createHistory() // onBack, onRefresh => channel.leave()

let socket = new Socket("/socket", {})
socket.connect()
export default socket

export const channel = (socket, game, player) =>
  socket.channel("game:" + game, {screen_name: player})

export const set_islands = (channel, player, islands) =>
  channel.push("set_islands", player, islands)

export const guess_coordinate = (channel, player, row, col) =>
  channel.push("guess_coordinate", {player, row, col})
