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
  {"a[b][d][]", 1}
  {"a[b][d][]", 2},
  {"a[b][f]", 4},
  {"c", 3}
]
```

which can be in turned into
```
"a[b][d][]=1&a[b][d][]=2&a[b][f]=4&c=3"
```
for communication with backend APIs.



## Longer Explanation

I couldn't find an Elixir package that serializes HTTP params as `maps` or nested `keyword lists` into a list of key-value pairs that many REST APIs (in Rails or similar MVC frameworks) require. So I've build one. Enjoy!


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add http_params_serializer to your list of dependencies in `mix.exs`:

        def deps do
          [{:http_params_serializer, "~> 0.0.1"}]
        end

  2. Ensure http_params_serializer is started before your application:

        def application do
          [applications: [:http_params_serializer]]
        end

