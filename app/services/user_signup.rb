class UserSignup  

  attr_reader :error_message

  def initialize(user)
    @user = user

  end

  def sign_up(stripe_token, invitation_token=nil)
    if @user.valid?
      charge = StripeWrapper::Customer.create(
        card: stripe_token,
        user: @user
      )

      if charge.successful?
        @user.save

        handle_invitation(invitation_token)
        AppMailerWorker.perform_async(@user.id)
        # othequitr options
        # AppMailer.delay.welcome_email(@user.id)
        # AppMailer.welcome_email(@user.id).deliver
        @status = :success
        self
      else
        @status = :failed
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
    @status == :success
  end

  private

  def handle_invitation(invitation_token)
    if invitation_token.present?
      invitation = Invitation.where(token: invitation_token).first
      invitation.inviter.follow(@user)
      @user.follow(invitation.inviter)
      invitation.update_columns(token: nil)
    end
  end
end