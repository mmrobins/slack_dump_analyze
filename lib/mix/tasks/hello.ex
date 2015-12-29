defmodule Mix.Tasks.Hello do
  use Mix.Task

  def run(_) do
    IO.puts "Foo"
    Mix.shell.info "hello"
  end
end
