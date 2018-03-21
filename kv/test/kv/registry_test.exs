defmodule KV.RegistryTest do
  use ExUnit.Case, async: true

  setup do
    # The advantage of using start_supervised! is that ExUnit will guarantee that the registry process will be shutdown before the next test starts. In other words, it helps guarantee the state of one test is not going to interfere with the next one in case they depend on shared resources.
    registry = start_supervised!(KV.Registry)
    # https://hexdocs.pm/ex_unit/ExUnit.Callbacks.html#start_supervised/2
    %{registry: registry}
  end

  test "spawns buckets", %{registry: registry} do
    assert KV.Registry.lookup(registry, "shopping") == :error

    KV.Registry.create(registry, "shopping")
    assert {:ok, bucket} = KV.Registry.lookup(registry, "shopping")

    KV.Bucket.put(bucket, "milk", 1)
    assert KV.Bucket.get(bucket, "milk") == 1
  end

  test "removes buckets on exit", %{registry: registry} do
    KV.Registry.create(registry, "shopping")

    {:ok, bucket} = KV.Registry.lookup(registry, "shopping")
    Agent.stop(bucket)

    assert KV.Registry.lookup(registry, "shopping") == :error
  end
end
