class PaymentsController < AdminController

  def index
    @payments = Payment.includes(:user).order("created_at DESC").limit(10).load
  end
end