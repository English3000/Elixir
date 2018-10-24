##  w-08-Aug-2018

if app crashes, how does that work?
  1. page refresh erases state -- can refetch via rejoin via query string
  2. server crashes -- supervisor would restart game (w/ saved state)
    * Does browser maintain history on crash? If so, same approach works...

      > From search, looks like browsers are built to be robust.
      > Also, when Firefox closes, it auto-opens my tabs.
      > If it restarts, I am able to restore my last session.

    * I'll assume the browser will handle it's own crashes; I'll just worry about the server.


##  m-06-Aug-2018

+ refactored `game_channel.ex` to properly handle crashes & page refreshes

***Now clear to build UI for joining game.***


## su-05-Aug-2018

+ adapted `game_channel.ex` to reply with/broadcast state to `socket.js`

  > More recently, I
  >
  >  * looked into CoffeeScript, as a cleaner syntax alternative to JavaScript (albeit, not for JSX)

  The end result will be that the `islands_display` (alpha tested in `svgs-practice`) frontend will have a functional rather than imperative design.

  > Additionally, I am exploring Elixir/simpler design patterns through this project.
  >
  > My purpose with a project is not just to rebuild something for a prospective employer, but rather to discover ways to minimize the friction between my having an idea and building it.
  >
  > Hence, I am seeking connection with technologies (and with people who can help to reduce that friction).

2. Build components around frontend channel methods.

3. _After_ completing (1), the next step is to setup `page_controller.ex` to fetch game state based on a query string **[FIRST, explore all potential designs--as I did w/ `server.ex`]**
