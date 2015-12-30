defmodule Mix.Tasks.Analyze do
  use Mix.Task

  def run(_) do
    require IEx
    File.cd("..")

    {:ok, t} = File.read "users.json"
    {:ok, users} = JSON.decode(t)

    user_map = users
    |> Enum.map(fn(u) -> {u["id"], u["name"]} end)
    |> Enum.into(%{})

    files = Path.wildcard("**/*.json")
    # non-parallel much slower
    #parsed_files = files
    #  |> Enum.map(fn(f) ->
    #    {:ok, t} = File.read(f)
    #    {:ok, day} = JSON.decode(t)
    #    day
    #  end)

    mapped_files = Enum.map(files, fn(f) ->
      Task.async(fn ->
        {:ok, t} = File.read(f)
        {:ok, day} = JSON.decode(t)
        day
      end)
    end)

    parsed_files = Enum.map(mapped_files, &Task.await/1)

    msg_per_user = fn(f, acc) ->
      msgs_per_file = Enum.reduce(f, %{}, fn(msg, file_count) ->
        uname = user_map[msg["user"]]
        current_count = Map.get(file_count, uname, 0)
        Map.put(file_count, uname, current_count + 1)
      end)
      Map.merge(msgs_per_file, acc, fn(_k, v1, v2) -> v1 + v2 end)
    end

    result = parsed_files
      |> Enum.reduce(%{}, msg_per_user)
      |> Enum.sort(fn(x, y) -> elem(y, 1) > elem(x, 1) end)
    IO.inspect Enum.take(result, -15)
    IEx.pry
  end

end
