defmodule ModestExTextTest do
  use ExUnit.Case
  doctest ModestEx

  test "all test cases from file" do
  
    File.open("test/fixtures/text.csv", [:read], fn(file) ->
      IO.binstream(file, :line)
      |> Stream.map(fn(line) ->
        # Enabled;Mode;Input;Selector;Text;Output
        matched = Regex.run(~r/^(0|1);(.*);(.*);(.*);(.*);(.*)$/, line)
        cond do
          matched != nil && Enum.count(matched) == 7 && Enum.at(matched, 1) == "1" ->
            mode = Enum.at(matched, 2)
            input = Enum.at(matched, 3)
            selector = Enum.at(matched, 4)
            text = Enum.at(matched, 5)
            case mode do
              "get" ->
                output = String.split(Enum.at(matched, 6), "|")
                test = cond do
                  mode == "get" and selector == "" -> ModestEx.get_text(input)
                  mode == "get" -> ModestEx.get_text(input, selector)
                end
                case test do
                  {:error, error} ->
                    raise RuntimeError,
                      "\n\tinput: " <> input <>
                      "\n\texpected: " <> Enum.join(output, "|") <>
                      "\n\terror: " <> error
                  reply ->
                    try do
                      assert reply == output
                    rescue
                      error in [ExUnit.AssertionError] -> 
                        raise ExUnit.AssertionError, error.message <> 
                          "\n\t reply: " <> Enum.join(reply, "|") <>
                          "\n\t test:  " <> line
                    end
                end
              "set" ->
                output = Enum.at(matched, 6)
                test = ModestEx.set_text(input, selector, text)
                case test do
                  {:error, error} ->
                    raise RuntimeError,
                      "\n\tinput: " <> input <>
                      "\n\texpected: " <> output <>
                      "\n\terror: " <> error
                  reply ->
                    try do
                      assert reply == output
                    rescue
                      error in [ExUnit.AssertionError] -> 
                        raise ExUnit.AssertionError, error.message <> 
                          "\n\t reply: " <> Enum.join(reply, "|") <>
                          "\n\t test:  " <> line
                    end
                end
            end
          true -> ""
        end
      end)
      |> Stream.run
    end)

  end

end
