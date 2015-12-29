defmodule Mix.Tasks.Analyze do
  use Mix.Task

  def run(_) do
    require IEx
    {:ok, t} = File.read "../users.json"
    {:ok, users} = Poison.decode(t)
  end

end
