require 'spec_helper'

feature "upload_video" do
  scenario "admin adds new video content" do
    admin = Fabricate(:admin)
    sign_in(admin)
    visit new_admin_video_path
    fill_in "Title", with: "Rio"
    select "Animated", from: 'Category'
    fill_in "Description", with: "This movie is for the birds."
    click_on "video_large_cover"
    choose_file "rio_large.jpg"
    click_on "video_small_cover"
    choose_file "rio_small.jpg"
    fill_in "Video Url", with: 'www.movie_url.com'
    click_on "Add Video"
    expect(page).to have_content("Video successfully added.")



  end
end