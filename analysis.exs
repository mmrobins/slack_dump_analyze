#require IEx
#IEx.pry
Code.require_file("deps/poison/lib/poison/parser.ex")
Code.require_file("deps/poison/lib/poison.ex")

users = File.read "users.json"
Poison.decode(users)
