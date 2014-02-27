Rails.configuration.stripe = {
  :publishable_key => ENV['STRIPE_PUBLISHABLE_KEY'],
  :secret_key      => ENV['STRIPE_SECRET_KEY']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]


# StripeEvent.setup do
#   subscribe 'charge.succeeded' do |event|
#     user = User.where(customer_token: event.data.object.customer).first
#     Payment.create(user: user, amount: event.data.object.amount, reference_id: event.data.object.id)
#   end
#   end
  

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded' do |event|
    event.data.object #=> #<Stripe::Charge:0x3fcb34c115f8>
  end
end