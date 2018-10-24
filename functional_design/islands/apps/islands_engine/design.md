# Islands Engine Interface

0. Start directory servers, connect to Phoenix socket on frontend

1. frontend components wrap channel methods
2. api's `game_channel.ex` `handle_in`s for each frontend method
3. `handle_in` may use backend's `server.ex` or `supervisor.ex` (which in turn may check against game rules)

> I'd separate channel methods in own file -- easier to reason about

  * `new_channel`
    1. => `"topic{game name}:subtopic{player}"` ~ creates channel object

  * `join`
    1. invoked
    2. `join/3` responds w/ socket object or error _-- game names aren't customizable_
    1. as of now -- error logged & unhandled (for other methods, on error, state set to error message hardcoded on frontend)

  * `new_game`
    1. pushes `"new_game"` message?
    2. gets topic (player name) from channel socket

## Data Flow

max: game = board + players
     player = hits, misses

**med:** fetch max when join game channel (change code so diff game names).
     when an action is taken, validate it w/ backend logic --
       frontend handles success or errors, updating state w/ data or error.

     in this sense, the backend manages state and validation.
     the frontend merely renders state & errors.
     and the api provides the means to persist state by connecting the two.

min: as is -- backend validates, frontend manages state...
     but that's like rebuilding a lot of the backend on the frontend
       (coupling) when its already there on the backend.

    best to maximally leverage what we've already built, rather than
      duplicate it.

## API
