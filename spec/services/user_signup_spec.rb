require 'spec_helper'

describe "user_signup", sidekiq: :inline do

    after {ActionMailer::Base.deliveries.clear}
    context "with valid personal input" do
      # let!(:alice) { Fabricate.build(:user)}
      context "and a successful credit card transaction" do
        before do
          customer = double(:customer, successful?: true)
          StripeWrapper::Customer.should_receive(:create).and_return(customer)
        end
        context "without invitation" do
          it "creates a user " do
            alice = Fabricate.build(:user)
            UserSignup.new(alice).sign_up(nil)

            expect(User.count).to eq(1)
          end
        end
        context "with an invitation" do
            let!(:inviter) { Fabricate(:user)}
            let!(:invite) { Fabricate(:invitation, inviter_id: inviter.id)}
            let!(:alice) { Fabricate.build(:user, email: invite.recipient_email)}
            before {UserSignup.new(alice).sign_up(nil,invite.token)}
            let!(:friend)  {User.where(email: invite.recipient_email).first}

          it "makes user follower inviter" do
            expect(friend.follows?(inviter)).to be_true
          end
          it "makes the inviter follow the user" do
            expect(inviter.follows?(friend)).to be_true
          end
          it "resets the invitation token" do
            expect(Invitation.first.token).to be_nil
            # or expect(invite.reload.token).to be_nil
          end
        end
        context "email sending" do
          let!(:alice) { Fabricate.build(:user, email:  'me@them.com', full_name: 'Victory')}
          before {UserSignup.new(alice).sign_up(nil)}
          it "sends out the email" do
            ActionMailer::Base.deliveries.should_not be_empty
          end
          it"sends to the right recipient" do
            message = ActionMailer::Base.deliveries.last
            message.to.should == ['me@them.com']
          end
          it "has the user name in the body" do
            message = ActionMailer::Base.deliveries.last
            message.body.should include('Victory')
          end
        end
      end
      context "and a declined card" do
        let!(:alice) { Fabricate.build(:user, email:  'me@them.com', full_name: 'Victory')}
        before do
          charge = double(:charge, successful?: false, error_message: "Your card was declined.")
          StripeWrapper::Customer.should_receive(:create).and_return(charge)
          UserSignup.new(alice).sign_up(nil)
        end
        it "should not create a user" do
          expect(User.count).to eq(0)
        end
        it "doesn't send an email" do
           expect(ActionMailer::Base.deliveries).to be_empty
        end
      end
    end

    context "with invalid input" do
       let!(:user) { Fabricate.build(:user,  full_name: nil)}
        before {UserSignup.new(user).sign_up(nil)}
      it "doesn't create a new user" do
        expect(User.count).to eq(0)
      end
      
      it "doesn't send out an email" do
        expect(ActionMailer::Base.deliveries.count).to eq(0)
        expect(ActionMailer::Base.deliveries).to be_empty
      end
      it "doesn't create a charge" do
        expect(StripeWrapper::Customer).to_not receive(:create)
      end
    end
  end



