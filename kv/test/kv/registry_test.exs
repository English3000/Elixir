defmodule KV.RegistryTest do
  use ExUnit.Case, async: true

  setup do
    # The advantage of using start_supervised! is that ExUnit will guarantee that the registry process will be shutdown before the next test starts. In other words, it helps guarantee the state of one test is not going to interfere with the next one in case they depend on shared resources.
    # https://hexdocs.pm/ex_unit/ExUnit.Callbacks.html#start_supervised!/2
    # if your application starts a supervision tree by running:
    #  Supervisor.start_link([MyServer, {OtherSupervisor, ...}], ...)
    # You can start those processes under test in isolation by running:
    #  start_supervised(MyServer)
    #  start_supervised({OtherSupervisor, :initial_value})
    # A keyword list can also be given if there is a need to change the child specification for the given child process (as opts)
    # start_supervised!(child_spec_or_module, opts \\ [])
    registry = start_supervised!(KV.Registry)
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
