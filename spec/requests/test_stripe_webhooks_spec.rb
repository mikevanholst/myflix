require 'spec_helper'

describe "test stripe webhooks" do
  let!(:event_data) do
   {
      "id" =>  "evt_103Zkm2osGI26Z416yTR2hsR",
      "created" =>  1393534877,
      "livemode" =>  false,
      "type" =>  "charge.succeeded",
      "data" =>  {
        "object" =>  {
          "id" =>  "ch_103Zkm2osGI26Z41KnyHA7LC",
          "object" =>  "charge",
          "created" =>  1393534877,
          "livemode" =>  false,
          "paid" =>  true,
          "amount" =>  999,
          "currency" =>  "cad",
          "refunded" =>  false,
          "card" =>  {
            "id" =>  "card_103Zkm2osGI26Z410ETXp26M",
            "object" =>  "card",
            "last4" =>  "4242",
            "type" =>  "Visa",
            "exp_month" =>  2,
            "exp_year" =>  2014,
            "fingerprint" =>  "yYUTBmoos0c1k1j3",
            "customer" =>  "cus_3Zkm0FSpuJqJFf",
            "country" =>  "US",
            "name" =>  nil,
            "address_line1" =>  nil,
            "address_line2" =>  nil,
            "address_city" =>  nil,
            "address_state" =>  nil,
            "address_zip" =>  nil,
            "address_country" =>  nil,
            "cvc_check" =>  "pass",
            "address_line1_check" =>  nil,
            "address_zip_check" =>  nil
          },
          "captured" =>  true,
          "refunds" =>  [],
          "balance_transaction" => "txn_103Zkm2osGI26Z41rxYEJnT7",
          "failure_message" =>  nil,
          "failure_code" =>  nil,
          "amount_refunded" =>  0,
          "customer" =>  "cus_3Zkm0FSpuJqJFf",
          "invoice" =>  "in_103Zkm2osGI26Z41G9VU047A",
          "description" =>  nil,
          "dispute" =>  nil,
          "metadata" =>  {}
        }
      },
      "object" =>  "event",
      "pending_webhooks" =>  1,
      "request" =>  "iar_3ZkmiQejAXDCDh"
      }
  end
  it "it creates a payment with a stripe webhook on a successful charge", :vcr do
    post "/stripe_events", event_data
    expect(Payment.count).to eq(1)
    

  end
end

