defmodule ModestEx.SetText do
  @moduledoc false
  
  def set_text([bin|bins], [text|texts]) do
    [set_text(bin, text)] ++ set_text(bins, texts)
  end

  def set_text([bin|bins], text) when is_bitstring(text) do
    [set_text(bin, text)] ++ set_text(bins, text)
  end

  def set_text([], _), do: []

  def set_text(bin, text) when is_bitstring(bin) when is_bitstring(text) do
    ModestEx.Safe.Attribute.set_text(bin, text)
  end

  def set_text([bin|bins], selector, [text|texts]) when is_bitstring(selector) do
    [set_text(bin, selector, text)] ++ set_text(bins, selector, texts)
  end

  def set_text([bin|bins], selector, text) when is_bitstring(selector) when is_bitstring(text) do
    [set_text(bin, selector, text)] ++ set_text(bins, selector, text)
  end

  def set_text([], _, _), do: []

  def set_text(bin, selector, text) when is_bitstring(bin) when is_bitstring(selector) when is_bitstring(text) do
    ModestEx.Safe.Text.set_text(bin, selector, text)
  end

end