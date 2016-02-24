defmodule HttpParamsSerializerTest do
  use ExSpec, async: true
  doctest HttpParamsSerializer

  describe ":HttpParamsSerializer" do
    def assert_output(i, o) do
      assert HttpParamsSerializer.normalize(i) == o
    end

    describe ":normalize" do
      it "accepts maps and converts them to keylists, so the result is same" do
        output = [{"a", 1}, {"b", 2}]
        assert_output %{a: 1, b: 2}, output
        assert_output [a: 1, b: 2], output
      end

      it "supports nesting" do
        assert_output %{a: %{b: 2}, c: 3},
          [{"a[b]", 2}, {"c", 3}]
      end

      it "supports deep nesting (> 2)" do
        assert_output %{a: %{b: %{d: [1,2], f: 4}}, c: 3},
          [{"a[b][d][]", 2}, {"a[b][d][]", 1}, {"a[b][f]", 4}, {"c", 3}]
      end

      it "serializes lists in a special way" do
        assert_output %{a: %{b: [1,2,3]}},
          [{"a[b][]", 3}, {"a[b][]", 2}, {"a[b][]", 1}]
      end

      it "sorts the items alphabetically for predictability" do
        input1 = %{z: 1, a: %{b: [1,2], c: 1} }
        input2 = %{a: %{b: [1,2], c: 1}, z: 1}
        input3 = %{a: %{c: 1, b: [1,2]}, z: 1}
        output = [{"a[b][]", 2}, {"a[b][]", 1}, {"a[c]", 1}, {"z", 1}]
        assert_output input1, output
        assert_output input2, output
        assert_output input3, output
      end
    end

    describe ":convert_map_to_list" do
      def assert_map_to_list(map, list) do
        assert list == map |> HttpParamsSerializer.convert_map_to_list
      end

      it "converts maps to lists" do
        assert_map_to_list(%{a: 1, b: 2}, [a: 1, b: 2])
        assert_map_to_list(%{a: 1, b: 2, c: %{d: 4}}, [a: 1, b: 2, c: [d: 4]])
        assert_map_to_list(%{a: 1, b: 2, c: %{d: 4, e: %{f: 6}}},
            [a: 1, b: 2, c: [d: 4, e: [f: 6]]])
      end

      it "does not retain order (we can't control the order of keys in maps!)" do
        assert_map_to_list(%{z: 1, a: %{b: [1,2], c: 1} },
            [a: [b: [1, 2], c: 1], z: 1] )
      end
    end
  end
end
