# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     WrapTest.Repo.insert!(%WrapTest.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias WrapTest.Repo
alias WrapTest.Accounts.{User, Link, Vote}
Repo.delete_all(User)


expert = %User{} |> User.changeset(%{ name: "Expert",
                                      email: "expert@user.io",
                                      password: "expert" }) |> Repo.insert!
  newb = %User{} |> User.changeset(%{ name: "Newb",
                                      email: "newb@user.io",
                                      password: "newb" }) |> Repo.insert!


   relay = %Link{ url: "https://facebook.github.io/relay/",
                  description: "Highly performant GraphQL client from Facebook",
                  user_id: expert.id } |> Repo.insert!
absinthe = %Link{ url: "https://hexdocs.pm/absinthe/overview.html",
                  description: "Elixir's implementation of GraphQL",
                  user_id: expert.id } |> Repo.insert!
