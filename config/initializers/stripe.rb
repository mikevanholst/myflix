Rails.configuration.stripe = {
  :publishable_key => ENV['STRIPE_PUBLISHABLE_KEY'],
  :secret_key      => ENV['STRIPE_SECRET_KEY']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded' do |event|
      user = User.where(customer_token: event.data.object.customer).first
      amount = event.data.object.amount
      reference_id = event.data.object.id
      Payment.create(user: user, amount: amount, reference_id: reference_id)
  end
end
