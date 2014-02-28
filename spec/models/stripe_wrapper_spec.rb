require 'spec_helper'
require 'vcr'

describe StripeWrapper do
  let(:valid_token) do
    token = Stripe::Token.create(
      :card => {
        :number => "4242424242424242",
        :exp_month => 2,
        :exp_year => 2018,
        :cvc => "314"
      }
    ).id
  end
  let(:invalid_token) do
    token = Stripe::Token.create(
      :card => {
        :number => "4000000000000002",
        :exp_month => 2,
        :exp_year => 2018,
        :cvc => "314"
      }
    ).id
  end

  describe StripeWrapper::Charge do
    describe ".create" do
      context "with a valid card" do
        it "creates a charge", :vcr  do
          response =  StripeWrapper::Charge.create(
            :amount => 400,
            :currency => "cad",
            :card => valid_token, 
            :description => "A valid Charge"
          )
          expect(response).to be_successful
        end
      end
      context "with an invalid card" do
        it "should not create a charge", :vcr  do
        response =  StripeWrapper::Charge.create(
            :amount => 400,
            :currency => "cad",
            :card => invalid_token, 
            :description => "A declined Charge"
            )
          expect(response).not_to be_successful
        end

        it "should set the error message", :vcr  do
          response =  StripeWrapper::Charge.create(
            :amount => 400,
            :currency => "cad",
            :card => invalid_token, 
            :description => "A declined Charge"
            )
          expect(response.error_message).to eq("Your card was declined.")
        end
      end
    end
  end

  describe StripeWrapper::Customer do
    describe ".create" do
      context "with an accepted card" do
        it "creates a customer", :vcr do
          alice = Fabricate(:user,  email: 'charity@third.ray')
          response =  StripeWrapper::Customer.create(
            user: alice,
            card: valid_token
          )
          expect(response).to be_successful
        end
        it "creates a customer", :vcr do
          alice = Fabricate(:user,  email: 'charity@third.ray')
          response =  StripeWrapper::Customer.create(
            user: alice,
            card: valid_token
          )
          expect(response.customer_token).to be_present
        end
      end
      context "with an invalid card" do
        it "does not create a customer", :vcr do
          alice = Fabricate(:user)
          response = StripeWrapper::Customer.create(
            user: alice,
            card: invalid_token
            )
          expect(response).not_to be_successful
        end
        it "sets the error message", :vcr do
          alice = Fabricate(:user)
          response = StripeWrapper::Customer.create(
            user: alice,
            card: invalid_token
            )
          expect(response.error_message).to eq("Your card was declined.")
        end
      end
    end
  end
end