# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Hackernews.Repo.insert!(%Hackernews.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Hackernews.Repo
alias Hackernews.Accounts.{Link, User}

Repo.delete_all(User)


expert = %User{name: "Expert"} |> Repo.insert!
  newb = %User{name: "Newb"}   |> Repo.insert!


relay = %Link{ url: "https://facebook.github.io/relay/",
               description: "Highly performant GraphQL client from Facebook",
               user_id: expert.id } |> Repo.insert!

absinthe = %Link{ url: "https://hexdocs.pm/absinthe/overview.html",
                  description: "Elixir's implementation of GraphQL",
                  user_id: expert.id } |> Repo.insert!
