defmodule HackernewsWeb.TokenAuth do
  @user_salt "resu_tlas"

  @doc """
  Encodes data into a signed token.
  """
  def sign(data), do: Phoenix.Token.sign(HackernewsWeb.Endpoint, @user_salt, data)

  @doc """
  On success, returns `{:ok, decoded_data}`.
  """
  def verify(token) do
    Phoenix.Token.verify(HackernewsWeb.Endpoint, @user_salt, token,
      [max_age: 365 * 24 * 3600])
  end
end
