# Slack Dump Analyze

check this out into the directory your slack dump is in

Then in the checkout dir run:

    mix deps.get # Why doesn't elixir or erlang have a built in json library?
    mix analyze

If you want to be able to put IEx.pry lines into the task run it with

    iex -S mix analyze

