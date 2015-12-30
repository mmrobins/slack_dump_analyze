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

    # non-parallel seems about 1/2 as fast
    parsed_files = files
      |> Enum.take(5)
      |> Enum.map(fn(f) ->
        {:ok, t} = File.read(f)
        {:ok, day} = Poison.decode(t)
        day
      end)

    #mapped_files = Enum.map(files, fn(f) ->
    #  Task.async(fn ->
    #    {:ok, t} = File.read(f)
    #    {:ok, day} = Poison.decode(t)
    #    day
    #  end)
    #end)

    #parsed_files = Enum.map(mapped_files, &Task.await/1)

    msg_per_user = fn(f, acc) ->
      msgs_per_file = Enum.reduce(f, %{}, fn(msg, acc) ->
        uname = user_map[msg["user"]]
        current_count = Map.get(acc, uname, 0)
        Map.put(acc, uname, current_count + 1)
      end)
      Map.merge(msgs_per_file, acc, fn(_k, v1, v2) -> v1 + v2 end)
    end

    result = parsed_files
      |> Enum.reduce(%{}, msg_per_user)
      |> Enum.sort(fn(x, y) -> elem(y, 1) > elem(x, 1) end)
    IO.inspect result
  end

end
