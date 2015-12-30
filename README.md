# Slack Dump Analyze

check this out into the directory your slack dump is in

Then in the checkout dir run:

    mix deps.get # Why doesn't elixir or erlang have a built in json library?
    mix analyze

If you want to be able to put IEx.pry lines into the task run it with

    iex -S mix analyze

So far I'm surprised this runs more slowly in Elixir than the equivalent I
cooked up in Ruby.  I think Ruby has a faster JSON parser.  I tried other JSON
parsers than Poison, but it's the only so far I've tried that works.

```ruby
require 'json'
require 'pp'

users = JSON.parse(File.read('users.json'))
user_map = users.inject({}) {|user_id_name,u| user_id_name[u["id"]] = u["name"]; user_id_name }

user_message_count = {}

Dir.glob("**/*.json").each do |day|
  JSON.parse(File.read(day)).each do |msg|
    uname = user_map[msg["user"]]
    user_message_count[uname] ||= 0
    user_message_count[uname] += 1
  end
end

pp user_message_count.sort_by {|_key, value| value}.to_h
```
