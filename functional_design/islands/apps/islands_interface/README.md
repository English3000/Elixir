* There's some issue with the umbrella's asset pipeline on deploy...

> ANSWER: Comment /priv/static in islands_interface/.gitignore

**TO DEPLOY APP:** `git subtree push --prefix functional_design/islands gigalixir master`

If issue, `git pull --rebase gigalixir master`

_(In the future, don't make project a sub-directory)_

## DONE! Next steps...

- [ ] mobile: + island setting functionality

- [ ] later, could add statistical features (i.e. wins, losses, && versus)

## CSR

Originally, I had completed "Functional Web Development with Elixir, OTP, and Phoenix". I looked at the frontend provided by this book and saw a lot of duplicate logic. So I refined the backend to remove as much duplication as I could.

I got to this cusp after realizing I had added some logic on the frontend which I could move over to my data structures on the backend. Also, I had island placement working (with a few kinks) and saw how slow re-rendering was.

When I moved the logic to the backend, I realized I could go all the way with SSR (hence I created that branch). Reflecting further, I realized it make more sense to move the business logic away from the backend to the frontend because SSR would result in a worse UX (as seen via the clunky re-rendering). As a result, the purpose of this branch is to remove backend validations and replace them with frontend ones--avoiding channel requests altogether.

Why? Why does one add a backend to one's project in the first place? To track state. If saving didn't matter, a game could be built entirely on the frontend. As a result, validations should be on the frontend and on success, state should be sent to the backend using `handle_in`.

The frontend should be a game on its own. The backend's job should be to receive game state and store it. In other words, the backend should consist of schemas (structs) rather than contexts (which should be moved to the frontend), and a server that simply saves to `dets` or restores a saved game.

# IslandsInterface

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).
