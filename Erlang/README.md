# Erlang

In all, this book gave me more confidence in my knowledge of this underlying layer of Elixir.

I
* became aware of a little more syntactic sugar (`01_erlang.ex`),
* gained a deeper understanding of `GenServer` (`/gen_server`),
* gained experience communicating between nodes (`04_name_server.ex`),
* gained comfort parsing files and binary (`/08_files`), and
* clarified my understanding Elixir concurrency (process primitives, `parallel.ex`).

Unfortunately, too many of the projects in this book did not work, and the projects were more of libraries (tools) than apps (websites/games).

I'm sure this will be a great reference manual, still, in certain instances.

But the main value was the social context, knowing the core of Erlang, and knowing I'm not missing anything fundamental in my knowledge of Elixir.

Onto **"Designing for Scalability with Erlang/OTP"**, which hopefully will be a more intermediate (and bug-free) book.

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `erlang` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:erlang, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/erlang](https://hexdocs.pm/erlang).
