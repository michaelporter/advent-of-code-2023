# Advent

Repo for Phoenix App that contains Advent of Code Solutions for 2023.

Running it via docker-compose:

```
docker-compose up --build
```

Or with an interactive iex shell

```
docker run --env ADVENT_SESSION_ID=$ADVENT_SESSION_ID -it advent-1 iex -S mix phx.server
```

Not sure how I'll structure the Solution context yet. Still need to make the results UI useful, but that can come when I have solution formats.

---

# Original Phoenix README Below: 

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
