defmodule Scraper do
  @moduledoc """
  A web scraper.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Scraper.hello
      :world

  """
  def get_data() do
    case HTTPoison.get("") do
      # https://www.google.com/search?q=web+scraper+in+elixir&ie=utf-8&oe=utf-8&client=firefox-b-1-ab
      # https://www.google.com/search?q=housing+prices+api&ie=utf-8&oe=utf-8&client=firefox-b-1-ab
    end
  end
end
