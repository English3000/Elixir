# 1: define bounded context for each workflow
#   (a series of functions consisting of types--often inputs & outputs--& steps--often sub-functions)

# (0) events
#
# Mail received => open_mail =>
#   Form received => order_or_quote =>
#     Order form received => place_order =>
#       Order placed to shipping dept => ship_order =>
#         Order shipped => signed_for delivery =>
#           Shipment received by customer
#         shipment Acknowledgment emailed to customer
#       Order placed to billing dept => ...
#       order Acknowledgment emailed to customer
#     Quote form received => give_quote =>
#       Quote provided
#
# Order change requested
# Order cancellation requested
# Return requested
# New customer request received
# New customer registered
#
#
# (1) bounded contexts (which interact via event "messages")
#
# core: order-taking, shipping,
# support: billing
# external: customer
#
# Workflow: Place order
#
# Order form received
# => Validate order [dependencies: Addresses db, Product catalog]
#   => (Unvalidated order ->) Validate customer_name
#   => Check that shipping_address & billing_address exist in Addresses db
#   => (For each order_line,) Check product_code syntax
#   => Check that product_code exists in Product catalog
#   -> return Validation error if invalid
# => (Validated order ->) Price order [dependencies: Product catalog]
#   => (For each order_line,) Get price from Product catalog
#   => Set order_line price
#   => Set amount_to_bill
# => (Priced order ->) Send acknowledgment_letter to customer
# => Order placed (event)


# based on seeing order form
#
# * dependency managment
# If our model wasn’t this complicated, we wouldn’t be capturing the requirements properly.
#
# bounded contexts listen for events from other bounded contexts
defmodule DDD.OrderTaking.Types do
  @spec place_order(unvalidated_order) :: place_order_events

  # search how to mark as async
  @spec validate_order(unvalidated_order) :: order_result
    @type unvalidated_order :: %{ order_id:          String.t,
                                  customer_info:     unvalidated_customer_info,
                                  shipping_address:  unvalidated_shipping_address,
                                  billing_address:   unvalidated_billing_address,
                                  order_lines:       list(unvalidated_order_line) }
    # validate customer_info, shipping_address, billing_address (via 3rd party tool)
    # validate order_lines by product code (via product catalog)
    # sum order_lines prices
    # mark as validated
      # UPDATE:
      @type unvalidated_order_line :: %{ product_code:   unvalidated_product_code,
                                         quantity:       unvalidated_order_quantity }

    @type order_result :: place_order_events | list(validation_error)

  @spec categorize_inbound_mail(envelope_contents) :: categorized_mail
    @type envelope_contents :: String.t
    @type categorized_mail :: quote_ | order

  @type validated_order :: %{ customer_info:     validated_customer_info,
                              shipping_address:  validated_shipping_address,
                              billing_address:   validated_billing_address,
                              order_lines:       [validated_order_line] }

    @type validated_order_line :: %{ product_code:   validated_product_code,
                                     quantity:       validated_order_quantity }

  @type place_order_events :: %{ acknowledgment_sent:    acknowledgment_sent,
                                 order_placed:           order_placed,
                                 billable_order_placed:  billable_order_placed }

  @type validation_error :: %{ name:    String.t,
                               details: String.t }

  @type place_order_error :: list(validation_error) # | other errors

  @type order :: %{ id:                order_id,
                    customer_id:       customer_id,
                    shipping_address:  shipping_address,
                    billing_address:   billing_address,
                    order_lines:       list(order_line),
                    amount_to_bill:    billing_amount }

    @type order_id :: type
    @type customer_id :: type
    @type customer_info :: type
    @type shipping_address :: type
    @type billing_address :: type
    @type price :: type

    @type order_line :: %{ id:              order_line_id,
                           order_id:        order_id,
                           product_code:    product_code,
                           order_quantity:  order_quantity,
                           price:           price }

      @type order_line_id :: type

      @type product_code :: widget_code | gizmo_code
        @typedoc "~r/W\d{4}/" # can't pattern match against a regex??
        @type widget_code :: String.t
        @typedoc "~r/G\d{3}/"
        @type gizmo_code :: String.t

      @type order_quantity :: unit | kilogram
        @type unit :: 1..1000
        @type kilogram :: 0.05..100.0

  @type priced_order :: %{ customer_info:     validated_customer_info,
                           shipping_address:  validated_shipping_address,
                           billing_address:   validated_billing_address,
                           order_lines:       [validated_order_line],
                           amount_to_bill:    amount_to_bill }

    @type priced_order_line :: %{ order_line:  validated_order_line,
                                  line_price:  line_price }

  @type placed_order_acknowledgment :: %{ priced_order:    priced_order,
                                          acknowledgment:  acknowledgment_letter }

  # consumer-driven (Place order -> Billing...)
  @type billable_order_placed :: %{ order_id:        order_id,
                                    billing_address: billing_address,
                                    amount_to_bill:  amount_to_bill}
end

# defmodule DDD.Orders.Types do
  @moduledoc """
  Domain types for use by our server.
  """

  # ===============================================================

  # bounded context: Order taking (consistent volume all year)
  # workflow: place order
    # triggered by... order form received (event--if not a quote)
    # inputs: order form

  # ORDER/QUOTE - (1) <unvalidated>,
  #                   {dependencies: product catalog, address checker app} ->
  #                     (validate order) ->
  #                       <validated> OR <validation error>
    # customer_name      -
    # customer_email      |
    # billing_address     |- via 3rd party app
    # shipping_address    |- using standard format
    # list of LINE ITEMs - all_valid?

  # (2) <validated> -> (price order)
    # subtotal           -
    # shipping_cost       |- <priced>
    # total              -

  # quote? (uses same form; just don't send internally)
  # express_delivery?

  # LINE ITEM - <unvalidated> (prioritize over quotes; invalid => deprioritized)
    # product_code  - validate via product catalog; codes don't really change; dependency mgmt over performance
      # widget_code - 1st validate starts w/ ~r/W[0-9]{4}/
        #OR
      # gizmo_code  - 1st validate starts w/ ~r/G[0-9]{3}/
    # quantity
      # widget -> unit   (1..100)
        #OR
      # gizmo  -> weight (0.05..100.00)
  # all_valid? => <validated> OR <validation error>

    # cost per unit
    # total cost - <priced>

  # ACKNOWLEDGMENT
  # (3) <priced> -> (send acknowledgment to customer) -> nil
    # priced ORDER
    # letter

  # output: order placed (notifications to shipping & billing depts)


  # bounded context: Product catalog

  # ===============================================================

  # defmodule Form do
  #   @type t :: %Form{ customer: String.t,
  #                     bill: String.t,
  #                     ship: String.t,
  #                     type: :atom,
  #                     orders: [Order.t] }
  #   defstruct [:customer, :bill, :ship, :type, :orders]
  # end
  #
  # defmodule Order do
  #   @type unit :: 1..1000
  #   @type kg :: 0.05..100.00
  #   @type t :: %Order{id: String.t, amount: unit, weight: kg}
  #   @enforce_keys [:id]
  #   defstruct [:id, :amount, :weight]
  # end
  #
  # defmodule Product do
  #   @type type :: atom
  #   @type code :: String.t
  #   @enforce_keys [:type, :code]
  #   defstruct [:type, :code]
  #   def valid?(%{type: type, code: code} = product) do
  #     regex = case type do
  #               :widget -> ~r/W[0-9]{4}/
  #               :gizmo  -> ~r/G[0-9]{3}/
  #             end
  #
  #     String.match?(code, regex)
  #   end
  # end

  # @doc """
  # Starts: "W" <> 4 digits
  # """
  # defmodule Widget do
  #   @type t :: %Widget{code: String.t}
  #   @enforce_keys [:code]
  #   defstruct [:code]
  #   def valid?(widget), do: String.match?(widget.code, ~r/W[0-9]{4}/)
  # end
  #
  # @doc """
  # Starts: "G" <> 3 digits
  # """
  # defmodule Gizmo do
  #   @type t :: %Gizmo{code: String.t}
  #   @enforce_keys [:code]
  #   defstruct [:code]
  #   def valid?(gizmo), do: String.match?(gizmo.code, ~r/G[0-9]{3}/)
  # end
# end
