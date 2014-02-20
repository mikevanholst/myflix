require 'spec_helper'

feature "User registration", {vcr: true, js: true} do
  background do 
    visit register_path
  end
  #first scenario with syntax for browser test
  scenario "Valid user info and card" , driver: :selenium do
    fill_in_valid_info
    fill_in_card("4242424242424242")
    click_on "Sign Up"
    expect(page).to have_content("Your subscription has been activated!")
  end
  scenario "valid user and expired card" do
    fill_in_valid_info
    fill_in_card("4000000000000002")
    click_on "Sign Up"
    expect(page).to have_content("Your card was declined")
  end
  scenario "valid user and invalid card" do
    fill_in_valid_info
    fill_in_card("123")
    click_on "Sign Up"
    expect(page).to have_content("This card number looks invalid")
  end
  scenario "invalid user and valid card" do
    enter_invalid_info
    fill_in_card("4242424242424242")
    click_on "Sign Up"
    expect(page).to have_content("Please fix the errors below")
  end
  scenario "invalid user and invalid card" do
    enter_invalid_info
    fill_in_card("123")
    click_on "Sign Up"
    expect(page).to have_content("This card number looks invalid")
  end
  scenario "invalid user and expired card" do
    enter_invalid_info
    fill_in_card("4000000000000002")
    click_on "Sign Up"
    expect(page).to have_content("Please fix the errors below")
  end
end

def fill_in_valid_info
  fill_in "Email Address", with: 'a@b.com'
  fill_in "Password", with: "test"
  fill_in "Full Name", with: "Bill Hill"
end

def enter_invalid_info
  fill_in "Email Address", with: 'a@b.com'
  fill_in "Password", with: "test"
end

def fill_in_card(card_number)
  fill_in "Credit Card Number", with: card_number
  fill_in "Security Code", with: "123"
  select "5 - May", from: 'date_month'
  select "2017", from: 'date_year'
end