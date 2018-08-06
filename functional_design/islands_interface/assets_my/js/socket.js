// TODO: Wrap functionality w/in React Native Web components (a la demo front end provided)
import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})
socket.connect()

const join_game = (socket, game, player) =>
  socket.channel("game:" + game, {screen_name: player}).join()
        .receive("ok",    response => {console.log("Joined channel!", response); return response})
        .receive("error", response => {console.log(response.reason)})

// const new_channel = (game, player) =>
//   socket.channel("game:" + game, {screen_name: player})
// let game_channel = new_channel("planets", "moon") // change for new game (rather than a restored one)
// game_channel.on("subscribers", response => {console.log("Current players online:", response)})
  // To see, in browser console, copy, paste, then type: game_channel.push("show_subscribers")

// const join = (channel) =>
//   channel.join()
//          .receive("ok",    response => {console.log("Joined channel!", response); return response})
//          .receive("error", response => {console.log(response.reason)})
// join(game_channel)

// Create a channel event function for each handle_in/3 clause in the GameChannel.
// Create a channel event function for each handle_in/3 clause in the GameChannel.
// unnecessary -- join now handles
/* const new_game = (channel) =>
  channel.push("new_game", channel.params.screen_name)
         .receive("ok",    response => {console.log("New game started!",         response)})
         .receive("error", response => {console.log("Failed to start new game.", response)}) */

// const add_player = (channel, player) =>
//   channel.push("add_player", player)
//          .receive("error", response => {console.log(`Could not add new player: ${player}`, response)})
// .on defines event listener
//                  event     callback (handler)
// game_channel.on("player_added", response => {console.log("Player added", response)})

const place_island = (channel, player, island, row, col) => //
  channel.push("place_island", {player, island, row, col})
         .receive("ok",    response => {console.log("Island placed.",          response)})
         .receive("error", response => {console.log("Could not place island.", response)})

const set_islands = (channel, player) =>
  channel.push("set_islands", player)
         .receive("ok",    response => {console.log("Board:"); console.dir(response.board);})
         .receive("error", response => {console.log(`Failed to set ${player}'s island.`)})
// game_channel.on("islands_set", response => {console.log("Player has set all islands", response)})

const guess_coordinate = (channel, player, row, col) =>
  channel.push("guess_coordinate", {player, row, col})
         .receive("error", response => {console.log(`${player} could not guess.`, response)})
// game_channel.on("guessed_coordinate", response => {console.log("Player made guess:", response.result)})

const exit = (channel) =>
  channel.exit()
         .receive("ok",    response => {console.log("Exited channel",         response)})
         .receive("error", response => {console.log("Failed to exit channel", response)})

// new_game(game_channel)
// new_game(game_channel) // to test error-handling
// add_player(game_channel, "sun")
// false negative: when join channel, if game already started, will already have 2 players => :error

export default socket
