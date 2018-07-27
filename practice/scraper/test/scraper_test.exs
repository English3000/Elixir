defmodule ScraperTest do
  use ExUnit.Case
  doctest Scraper

  test "greets the world" do
    assert Scraper.hello() == :world
  end
end
