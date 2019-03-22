import { Socket, Channel } from "phoenix"
import createHistory from "history/createBrowserHistory"
// TODO: onBack, onRefresh => channel.leave()
export const history = createHistory()
const socket = new Socket("/socket") // path in `endpoint.ex`

socket.connect()
export default socket

export const channel = (socket : Socket, game : string, player : string) =>
  socket.channel("game:" + game, {screen_name: player})

type Payload1 = { player : string, islands : {} }
export const set_islands = (channel : Channel, payload : Payload1) =>
  channel.push("set_islands", payload)

type Payload2 = { player : string, row : number, col : number }
export const guess_coordinate = (channel : Channel, payload : Payload2) =>
  channel.push("guess_coordinate", payload)
