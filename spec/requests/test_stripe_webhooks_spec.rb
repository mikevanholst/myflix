require 'spec_helper'

describe "test stripe webhooks" do
  let(:event_data) do
    {
      id: "ch_103ZNM2osGI26Z41JD0jWOku", #was variable
      object: "charge",
      created: 1393447706,
      livemode: false,
      paid: true,
      amount: 999,
      currency: "cad",
      refunded: false,
      card:
      {
        id: "card_103ZNM2osGI26Z41NTvSGZ7z", #was variable
        object: "card",
        last4: "4242",
        type: "Visa",
        exp_month: 2,
        exp_year: 2014,
        fingerprint: "yYUTBmoos0c1k1j3",
        customer: "cus_3ZNMjdxHXqmu4C", #was variable
        country: "US",
        name: nil,
        address_line1: nil,
        address_line2: nil,
        address_city: nil,
        address_state: nil,
        address_zip: nil,
        address_country: nil,
        cvc_check: "pass",
        address_line1_check: nil,
        address_zip_check: nil,
      },

      captured: true,
      refunds:  {},
      balance_transaction: "txn_103ZNM2osGI26Z41IL390k5D",
      failure_message: nil,
      failure_code: nil,
      amount_refunded: 0,
      customer: "cus_3ZNMjdxHXqmu4C",  #was variable
      invoice: "in_103ZNM2osGI26Z41S6UhDDpV",  #was variable
      description: nil,
      dispute: nil,
      metadata:  
      {}
    }
  end
  it "it creates a payment with a stripe webhook on a successful charge", :vcr do
    post "/stripe_events", event_data
    expect(Payment.count).to eq(1)
  end
end