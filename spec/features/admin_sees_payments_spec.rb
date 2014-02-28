require 'spec_helper'

feature "admin sees payments" do
  scenario "logged in as admin" do
    alice = Fabricate(:user, admin: true)
    bob = Fabricate(:user, full_name: "Bob", customer_token: "abcdefg")
    sign_in(alice)
    new_payment = Fabricate(:payment, user_id: bob.id)
    click_link "Recent Payments"
    expect(page).to have_content "$9.99"
    expect(page).to have_content "Bob"
  end
  scenario "logged in as reqular user" do
    bob = Fabricate(:user, full_name: "Bob", customer_token: "abcdefg")
    new_payment = Fabricate(:payment, user_id: bob.id)
    sign_in(bob)
    page.should_not have_css 'a', text: "Recent Payments"
    visit payments_path
    expect(page).not_to have_content "$9.99"
    expect(page).to have_content "You are not authorized for that action."        
  end
end

