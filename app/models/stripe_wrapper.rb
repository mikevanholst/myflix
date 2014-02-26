module StripeWrapper 
  class Charge
  attr_reader :error_message, :response

    def initialize(options={})
      @response = options[:response]
      @error_message = options[:error_message]
    end

    def self.create(options={})
      begin
        response = Stripe::Charge.create(
          amount: options[:amount],
          currency: "cad",
          card: options[:card],
          description: options[:description]
          )
        new(response: response)
      rescue Stripe::CardError => e
        new(error_message: e.message )  
      end
    end

    def successful?
      response.present?
    end
  end

  class Customer
     attr_reader :response, :error_message

    def initialize(options={})
      @response = options[:response]
      @error_message = options[:error_message]
    end

    def self.create(options={})
      begin
        response = Stripe::Customer.create(
          card: options[:card],
          plan: "base",
          email: options[:user].email
          )
        new(response: response)
      rescue Stripe::CardError => e
        new(error_message: e.message)
      end
    end

    def successful?
      response.present?
    end
  end
end


# # STRIPE_PUBLISHABLE_KEY:   pk_test_e3m9e3RoRew11vPH0hS6Pfkv 
# # STRIPE_SECRET_KEY:        sk_test_ZXmRrGWE6grWtUlQrKCFGadQ