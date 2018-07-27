defmodule PlateSlateWeb.Types.Accounts do
  use Absinthe.Schema.Notation
  alias PlateSlateWeb.Resolvers

  # object :accounts_inputs do
  #   field :sign_in, :session do
  #     arg :email, non_null(:string)
  #     arg :password, non_null(:string)
  #     arg :role, non_null(:role)
  #     resolve &Resolvers.Accounts.sign_in/3
  #     middleware fn reso, _ -> with %{value: %{user: user}} <- reso do
  #       %{reso | context: Map.put(reso.context, :current_user, user)}
  #     end end
  #   end
  # end

  object :session do
    field :token, :string
    field :user, :user
  end

  interface :user do
    field :email, :string
    field :name, :string
    resolve_type fn
      %{role: "employee"}, _ -> :employee
      %{role: "customer"}, _ -> :customer
    end
  end

  enum :role do
    value :employee
    value :customer
  end

  object :employee do
    interface :user
    field :email, :string
    field :name, :string
  end

  object :customer do
    interface :user
    field :email, :string
    field :name, :string
    field :orders, list_of(:order) do
      resolve fn customer, _,_ ->
        import Ecto.Query

        orders = PlateSlate.Ordering.Order
          |> where(customer_id: ^customer.id)
          |> PlateSlate.Repo.all

        {:ok, orders}
      end
    end
  end
end
