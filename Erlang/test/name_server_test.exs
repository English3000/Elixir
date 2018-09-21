defmodule NameServerTest do
  use ExUnit.Case, async: true

  setup_all do
    NameServer.start
    :ok
  end

  doctest NameServer
end
