defmodule PipeTest do
  use ExUnit.Case
  doctest ModestEx

  test "build up a complete DOM" do
    result = ""
    |> ModestEx.serialize()
    |> ModestEx.append("body", "<div>")
    |> ModestEx.set_attribute("body > div", "class", "col-md-12")
    |> ModestEx.append("body > div", "<div>")
    |> ModestEx.set_attribute("div.col-md-12 div", "class", "col-md-6")
    |> ModestEx.append("div.col-md-12 div", "<a></a>")
    |> ModestEx.set_text("a", "Hello")

    copy = ModestEx.find(result, "div.col-md-12 div")
    |> ModestEx.set_text("a", "World")
    
    result = ModestEx.insert_after(result, "div.col-md-12 div", copy)
    |> ModestEx.set_attribute("div.col-md-6:first-of-type a", "href", "https://elixir-lang.org")
    |> ModestEx.set_attribute("div.col-md-6:last-of-type a", "href", "https://google.de")
    
    assert result == "<div class=\"col-md-12\"><div class=\"col-md-6\"><a href=\"https://elixir-lang.org\">Hello</a></div><div class=\"col-md-6\"><a href=\"https://google.de\">World</a></div></div>"
  end

  test "more complex transformation" do
    result = "<div><div><a>Hello</a></div><div><a>World</a></div></div>"
    |> ModestEx.set_attribute("body > div", "class", "col-md-12")
    |> ModestEx.set_attribute("div.col-md-12 div", "class", "col-md-6")
    |> ModestEx.set_attribute("div.col-md-6:first-of-type a", "href", "https://elixir-lang.org")
    |> ModestEx.set_attribute("div.col-md-6:last-of-type a", "href", "https://google.de")

    assert result == "<div class=\"col-md-12\"><div class=\"col-md-6\"><a href=\"https://elixir-lang.org\">Hello</a></div><div class=\"col-md-6\"><a href=\"https://google.de\">World</a></div></div>"
  end

end
