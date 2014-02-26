require 'spec_helper'

describe UsersController do

  describe "GET new" do
    it "sets the @user variable" do
      user = Fabricate(:user)
      get :new
      assigns(:user).should be_new_record
      assigns(:user).should be_instance_of(User)
    end
  end

  describe "GET new_with_invitation_token" do
    context "with a valid invite" do
      let!(:invite) {Fabricate(:invitation)}
      before { get :new_with_invitation_token, token: invite.token}
      it "should render the new template" do
         expect(response).to render_template :new
      end
      it "should prefill the address" do
        expect(assigns(:user).email).to eq(invite.recipient_email)
      end
      it "should set the token" do
        expect(assigns(:invitation_token)).to eq(invite.token)
      end
    end
    context "with invalid token" do
      it "should redirect to the expired  token page" do
        get :new_with_invitation_token, token: '987asd98sad7f'
         expect(response).to redirect_to failed_token_path
      end
    end
  end

  describe "POST create" do
    context "with successful sign up" do
      it "should redirect to home page" do
        result = double(:result, successful?: true)
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to home_path
      end
    end
    context "with failed sign up" do
      before do
        result = double(:result, successful?: false, error_message: "Service error message")
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
      end
      it "should set the error message" do
        expect(flash[:danger]).to eq("Service error message")
      end
      it "should redirect to sign_up" do
        expect(response).to render_template "new"
      end
      it "sets the @user" do
        expect(assigns(:user)).to be_instance_of(User)
      end
    end
  end


  describe "GET show" do
    it_behaves_like "requires sign in" do
      let(:action) {get :show, id: 3}
    end
    it "should set @user" do
      alice = Fabricate(:user)
      session[:user_id] = alice.id
      get :show, id: alice.id
      expect(assigns(:user)).to eq(alice)
    end
  end
end  