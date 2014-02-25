require 'spec_helper'
require 'vcr'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe ".create" do
      context "with a valid card" do
        it "creates a charge", :vcr  do

          token = Stripe::Token.create(
            :card => {
              :number => "4242424242424242",
              :exp_month => 2,
              :exp_year => 2018,
              :cvc => "314"
            }
          ).id

         response =  StripeWrapper::Charge.create(
            :amount => 400,
            :currency => "cad",
            :card => token, 
            :description => "A valid Charge"
          )
          expect(response).to be_successful
        end
      end
      context "with an invalid card" do
       

        it "should not create a charge", :vcr  do
           token = Stripe::Token.create(
            :card => {
              :number => "4000000000000002",
              :exp_month => 2,
              :exp_year => 2018,
              :cvc => "314"
            }
          ).id

          response =  StripeWrapper::Charge.create(
            :amount => 400,
            :currency => "cad",
            :card => token, 
            :description => "A declined Charge"
            )
          expect(response).not_to be_successful
        end

        it "should set the error message", :vcr  do
           token = Stripe::Token.create(
            :card => {
              :number => "4000000000000002",
              :exp_month => 2,
              :exp_year => 2018,
              :cvc => "314"
            }
          ).id

          response =  StripeWrapper::Charge.create(
            :amount => 400,
            :currency => "cad",
            :card => token, 
            :description => "A declined Charge"
            )
          expect(response.error_message).to eq("Your card was declined.")
        end
      end
    end
  end
end