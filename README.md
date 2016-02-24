# HttpParamsSerializer


## tl;dr

Turns this datastructure

```elixir
%{a:
  %{b:
    %{
      d: [1,2],
      f: 4
    }
  },
  c: 3
}
```

into this
```elixir
[
  {"a[b][d][]", 1},
  {"a[b][d][]", 2},
  {"a[b][f]", 4},
  {"c", 3}
]
```

which can be easily turned into
```
"a[b][d][]=1&a[b][d][]=2&a[b][f]=4&c=3"
```
for communication with backend APIs.



## Longer Explanation

I couldn't find an Elixir package that serializes HTTP params as `maps` or nested `keyword lists` into a list of key-value pairs that many REST APIs (in Rails or similar MVC frameworks) require. So I've build one. Enjoy!


## Usage

```elixir
iex> params = %{id: "aaa-1234",
  account: %{name: "Best", last_name: "User Eva"},
  balance: %{limit: 1000, currency: "$", balance: 1500},
  roles: ["admin", "manager", "staff"]
}
%{account: %{last_name: "User Eva", name: "Best"},
  balance: %{balance: 1500, currency: "$", limit: 1000}, id: "aaa-1234"}
iex> params |> HttpParamsSerializer.serialize
[[{"account[last_name]", "User Eva"}, {"account[name]", "Best"},
 {"balance[balance]", 1500}, {"balance[currency]", "$"},
 {"balance[limit]", 1000}, {"id", "aaa-1234"}, {"roles[]", "staff"},
 {"roles[]", "manager"}, {"roles[]", "admin"}]
```



## Installation
  1. Add http_params_serializer to your list of dependencies in `mix.exs`:

        def deps do
          [{:http_params_serializer, "~> 0.1"}]
        end


## License
Copyright © 2016 Roman Heinrich <roman.heinrich@gmail.com>

This work is free. You can redistribute it and/or modify it under the
terms of the MIT License. See the LICENSE file for more details.
