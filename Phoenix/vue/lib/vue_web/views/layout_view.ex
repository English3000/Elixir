defmodule VueWeb.LayoutView do
  use VueWeb, :view

  def concat({:safe, template}, {:safe, eex}), 
    do: {:safe, [template | eex]}
end
