# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
alias Graphql.{News.Link, Repo}

%Link{url: "http://graphql.org",
      description: "A great new query language!"}
      |> Repo.insert!
%Link{url: "http://dev.apollodata.com",
      description: "AWESOME GraphQL client"}
      |> Repo.insert!
