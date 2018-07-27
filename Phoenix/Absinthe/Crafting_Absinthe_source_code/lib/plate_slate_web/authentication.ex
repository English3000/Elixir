defmodule PlateSlateWeb.Authentication do
  @user_salt "user salt"

  @doc """
  Encodes data into a signed token.
  """
  def sign(data) do
    Phoenix.Token.sign(PlateSlateWeb.Endpoint, @user_salt, data)
  end

  @doc """
  On success, returns `{:ok, decoded_data}`.
  """
  def verify(token) do
    Phoenix.Token.verify(PlateSlateWeb.Endpoint, @user_salt, token,
      [max_age: 365 * 24 * 3600])
  end
end
