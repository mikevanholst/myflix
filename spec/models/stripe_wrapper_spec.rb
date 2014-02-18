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
         # binding.pry
          # expect(response.amount).to eq(400)
          # expect(response.currency).to eq("cad")
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

    #   context "with valid inputs" do
    #     alice = Fabricate(:user)
    #     context "and a valid card" do

       
    #       it "should redirect to the home page"
    #       it "should create the user"
    #       it "should charge the card"
    #       it "should set the success mmessage"
    #     end

    #     context "and a declined card" do
    #       it "should redirect to the new path"
    #       it "should not create a user"
    #       it "should not charge the card"
    #       it "should display the error message"
    #     end
    #   end

    #   context "with invalid inputs" do
    #     it "should redirect to the new path"
    #     it "should not create a user"
    #     it "should not charge the card"
    #     it "should display the error message"
    #   end
    end
  end
end