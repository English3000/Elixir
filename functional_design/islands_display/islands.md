# Islands

The team already has the game logic setup.

We also have a Phoenix server with all the functions to communicate/interface with the channel.

We need you to create a UI for the game.

## Issues w/ Book Code

On refresh, the game page is lost. So, while the backend remembers the state, the frontend does not.

The best solution is to include the game & player in a query string -- using `withRouter` from `'react-router-dom'` -- so on refresh, these two can be used to rejoin the channel & game.


> Component Hierarchy
>
>  -------------------------------
> |       FORM &  / game status
> |       errors /  OR instructions
> |
> |        -------------------------
> |       |
> |       |
> |       |
> |       |
> |       |       BOARD
> |       |       * displays guesses
> |       |       * displays islands if own board
> |       |
> |       |
> |        -------------------------
> |
> |        -------------------------
> |       |       ISLANDS (drag onto board; -- no display of oppt's islands
> |       |                when empty, converts to "Confirm Board" button;
> |       |   upon confirmation, game status changes & this area disappears)
> |        -------------------------
> |
>  -------------------------------



## UI

The basic flow I have in mind is

1. Join a game (creates a new_channel for player & join's it):
  * `<TextInput value={game}/>`
  * `<TextInput value={player}/>`
  * `<Checkbox value="new game?"/>`
  * `<Button onClick={(game, player) => {const game_channel = new_channel(game, player); join(game_channel)} }`

> new game error: game name taken

> existing game errors: game not found, game filled

> player name error: "Other player has this name. Please choose another."

If game exists,

  * i.   If you're one of the players, resumes game w/ current board stage & state
  * ii.  If there's no `player2`, you enter as `player2`
  * iii. If there are already 2 players, an error message is displayed & you search for another game

2. Displays:
  ```js

  <Text>{player1}: {status1}<Text/>  |  <Text>{player2}: {status2}<Text/>

  ```
  * if no second player, `player2` displays message, e.g. `Waiting for another player to join...`

> Stages:
>
> * setting one's islands
> * taking a turn
> * when game is over, requesting a rematch
>
> \+ Player stats (e.g. win-loss record)

------

This is what the project roadmap would look like. However, I don't think finishing this (today) is the best investment.

The logic for channels is important.

> For today, play with the `react-native-svg` library.
