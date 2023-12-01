FROM elixir:latest
# FROM elixir-base

# CMD echo "Test - we're in!"
WORKDIR /elixir-app
# VOLUME [ "/elixir-app/advent" ]

COPY . .
# docker run -it elixir-env-1 iex

RUN apt-get update && apt-get install inotify-tools -y

RUN mix local.hex --force

# RUN mix archive.install hex phx_new --force
# RUN mix phx.new advent --no-ecto

WORKDIR /elixir-app/advent

RUN mix deps.get
RUN mix local.rebar --force

EXPOSE 4000

# CMD ["elixir", "index.exs"]_

CMD ["mix", "phx.server"]
# CMD ["iex", "-S", "mix", "phx.server"]