import { Socket } from "phoenix"
import createHistory from "history/createBrowserHistory"
import { Platform } from "react-native"

export const history = createHistory() // TODO: onBack, onRefresh => channel.leave()
                        // v-- path in `endpoint.ex`
const socket = new Socket("/socket", {params: window.params})//, {params: {token: window.userToken}})

socket.connect()
export default socket

export const channel = (socket, game, player) =>
  socket.channel("game:" + game, {screen_name: player})

export const set_islands = (channel, player, islands) =>
  channel.push("set_islands", player, islands)

export const guess_coordinate = (channel, player, row, col) =>
  channel.push("guess_coordinate", {player, row, col})
