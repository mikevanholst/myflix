class UserSignup  

  attr_accessor @status, @error_message

  def initialize(user)
    @user = user
    @amount = 999
  end

  def sign_up(stripe_token, invitation_token)
    if @user.valid?
      charge = StripeWrapper::Charge.create(
        :card  => @stripe_token,
        :amount      => @amount,
        :description => "subscription charge for #{@user.email}",
      )
      if charge.successful?
        @user.save
        AppMailerWorker.perform_async(@user.id)
        # other options
        # AppMailer.delay.welcome_email(@user.id)
        # AppMailer.welcome_email(@user.id).deliver
        handle_invitation
        @status = 'succeeded'
        self
      else
        @status = 'failed'
        @error_message =  charge.error_message
        self
      end
    else
      @status = 'failed'
      @error_message =  "Please fix the errors below."
      self
    end
  end

  def successful?
    @status == 'succeeded'
  end

  private

  def handle_invitation
    if invitation_token.present?
      invitation = Invitation.where(token: invitation_token).first
      invitation.inviter.follow(@user)
      @user.follow(invitation.inviter)
      invitation.update_columns(token: nil)
    end
  end
end