defmodule Mix.Tasks.JsonParse do
  use Mix.Task

  def run(_) do
    {:ok, t} = File.read "/Users/matt/graphite_stats_names.json"
    # Ruby runs this a *lot* faster
    # % time ruby -e "require 'json'; 10.times { JSON.parse(File.read('/Users/matt/graphite_stats_names.json')) }"
    # ruby -e   1.33s user 0.29s system 91% cpu 1.776 total
    # % time mix json_parse
    # mix json_parse  6.47s user 0.64s system 101% cpu 7.020 total

    Enum.each(1..10, fn(_) -> Poison.Parser.parse!(t) end)
  end

end
