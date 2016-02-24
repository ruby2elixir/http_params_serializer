defmodule HttpParamsSerializer do
  @moduledoc """
  A small library to serialize deeply nested datastructures into HTTP parameters that most backends do understand.
  """


  def serialize(params) when is_map(params) do
    params |> convert_map_to_list |> serialize
  end


  @doc """
  Example:
      iex> [a: [b: [d: [1, 2], f: 4]], c: 3] |> HttpParamsSerializer.serialize
      [{"a[b][d][]", 2}, {"a[b][d][]", 1}, {"a[b][f]", 4}, {"c", 3}]


      iex> %{ a: %{ b: %{ d: [1,2], f: 4 } }, c: 3 } |> HttpParamsSerializer.serialize
      [{"a[b][d][]", 2}, {"a[b][d][]", 1}, {"a[b][f]", 4}, {"c", 3}]
  """
  def serialize(params) when is_list(params) do
    serialize("", params, [])
  end

  defp serialize(namespace, [{k, v}|t], acc) when is_list(v) do
    cond do
      Keyword.keyword?(v) ->
        res = serialize(field_name(namespace, k), v, [])
        serialize(namespace, t, res ++ acc  )
      true -> # we have a normal list, special fieldname required!
        res = Enum.map(v, fn(x)-> {field_name(:array, namespace, k), x} end)
        serialize(namespace, t, res ++ acc )
    end
  end

  defp serialize(namespace, [{k, v}|t], acc) do
    serialize(namespace, t, [ {field_name(namespace, k), v} | acc ])
  end

  # reverse + sorting only needed at the end of empty (== root) namespace
  defp serialize("", [], acc) do
    acc |> Enum.reverse |> Enum.sort_by(fn({k,_v})-> k end )
  end
  defp serialize(_namespace, [], acc),  do: acc

  defp field_name(namespace, field) do
    case namespace do
      "" -> "#{field}"
      _  -> "#{namespace}[#{field}]"
    end
  end

  defp field_name(:array, namespace, field) do
    case namespace do
      "" -> "#{field}[]"
      _  -> "#{namespace}[#{field}][]"
    end
  end


  @doc """
  Little helper funciton to recursivelly convert a map into a nested keyword list.

  Example:
      iex> %{a: 1, b: %{c: %{d: 2}}} |> HttpParamsSerializer.convert_map_to_list
      [a: 1, b: [c: [d: 2]]]
  """
  def convert_map_to_list(map) when is_map(map) do
    map
      |> Map.to_list
      |> Enum.map( fn({k,v})-> {k, convert_map_to_list(v)} end)
  end
  def convert_map_to_list(map), do: map
end
