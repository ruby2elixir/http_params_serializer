defmodule HttpParamsSerializer do
  def serialize(params) when is_map(params) do
    params |> convert_map_to_list |> serialize
  end

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

  def convert_map_to_list(map) when is_map(map) do
    map
      |> Map.to_list
      |> Enum.map( fn({k,v})-> {k, convert_map_to_list(v)} end)
  end
  def convert_map_to_list(map), do: map
end
