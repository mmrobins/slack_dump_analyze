# Slack Dump Analyze

check this out into the directory your slack dump is in

Then in the checkout dir run:

    mix deps.get # Why doesn't elixir or erlang have a built in json library?
    iex -S mix analyze

