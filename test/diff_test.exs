defmodule DiffTest do
  use ExUnit.Case
  
  @doc """
  Compares 2 terms that have an implementation of the Diff.Diffable protocol and returns a list of changes from the first given binary with the second

  https://github.com/bryanjos/diff

  """
  test "diff html" do
    result = Diff.diff("<div><p>Hello</p></div>", "<div><p>World</p></div>", [:keep_unchanged])
    |> IO.inspect

    # returns...
    
    # [
    #   %Diff.Delete{element: ["H", "e", "l", "l"], index: 8, length: 4},
    #   %Diff.Insert{element: ["W"], index: 8, length: 1},
    #   %Diff.Insert{element: ["r", "l", "d"], index: 10, length: 3}
    # ]

  end

  
end
