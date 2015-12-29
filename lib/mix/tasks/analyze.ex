defmodule Mix.Tasks.Analyze do
  use Mix.Task

  def run(_) do
    require IEx
    File.cd("..")

    {:ok, t} = File.read "users.json"
    {:ok, users} = Poison.decode(t)

    user_map = users
    |> Enum.map(fn(u) -> {u["id"], u["name"]} end)
    |> Enum.into(%{})

    files = Path.wildcard("**/*.json")
    files
    mapped_files = Enum.map(files, fn(f) ->
      Task.async(fn ->
        {:ok, t} = File.read(f)
        {:ok, day} = Poison.decode(t)
        day
      end)
    end)
    parsed_files = Enum.map(mapped_files, &Task.await/1)
    IEx.pry
  end

end
