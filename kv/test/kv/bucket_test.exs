defmodule KV.BucketTest do
  # `async: true` makes the test case run in parallel with other :async test cases by using multiple cores in our machine. This is extremely useful to speed up our test suite. However, :async must only be set if the test case does not rely on or change any global values.

  # if the test requires writing to the filesystem or access a database, keep it synchronous (omit the :async option) to avoid race conditions between tests.
  use ExUnit.Case, async: true

  setup do
    bucket = start_supervised!(KV.Bucket)
    %{bucket: bucket}
  end

  # All tests receive a context as an argument.
  # `%{bucket: bucket}` destructures context received from setup block
  test "stores values by key", %{bucket: bucket} do
    assert KV.Bucket.get(bucket, "milk") == nil

    KV.Bucket.put(bucket, "milk", 3)
    assert KV.Bucket.get(bucket, "milk") == 3

    assert KV.Bucket.delete(bucket, "milk") == 3

    assert KV.Bucket.get(bucket, "milk") == nil
  end
end
