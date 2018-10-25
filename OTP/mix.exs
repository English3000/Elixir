defmodule OTP.MixProject do
  use Mix.Project

  def project, do: [
    app: :otp,
    version: "0.1.0",
    elixir: "~> 1.7.3",
    start_permanent: Mix.env() == :prod,
    deps: deps()
  ]

  defp deps, do: [
    {:gen_state_machine, "~> 2.0"},
    {:gen_stage, "~> 0.14.1"}
  ]

  def application, do: [
          applications: [:gen_state_machine],
    extra_applications: [:logger, :crypto]
  ]
end

# re: :crypto,
# https://www.djm.org.uk/posts/cryptographic-hash-functions-elixir-generating-hex-digests-md5-sha1-sha2/
# "don't use [:crypto] for storing passwords,
#  hashing algorithms are too fast,
#  what you want is a key derivation function
#  as they are more suitable for preventing brute forcing attacks -
#  use extensive rounds of bcrypt or PBKDF2 instead."
