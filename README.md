# EctoCQS

Inspired by [Command-Query separation in Elixir](https://blog.lelonek.me/command-query-separation-in-elixir-ac742e60fc7d).

Library is fully operational and is used in several projects in production
but still everything is "subject to change without prior notice".

Maybe I'll add typespecs and documentation later but for now feel free to
examine source code and tests in particular to understand how it all works.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ecto_cqs` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ecto_cqs, "~> 0.1"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ecto_cqs](https://hexdocs.pm/ecto_cqs).

## Running tests

```sh
$ git clone https://github.com/tap349/ecto_cqs
$ cd ecto_cqs
$ mix deps.get
$ docker-compose up
$ MIX_ENV=test mix ecto.create
$ MIX_ENV=test mix ecto.migrate
$ mix test
```
