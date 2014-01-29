shared_examples "requires sign in" do
  it "should redirect to the sign in page" do
    clear_session
    action
    expect(response).to redirect_to sign_in_path
  end
 end