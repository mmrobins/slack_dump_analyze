defmodule Mix.Tasks.Analysis do
  use Mix.Task

  def run(_) do
    Mix.shell.info "hello"
    IO.puts "HELLO"

    users = File.read "users.json"
    require IEx
    IEx.pry

    IO.puts "GOODBYE"
  end
end

