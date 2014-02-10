require 'spec_helper'

feature "upload_video" do
  scenario "admin adds new video content" do
    admin = Fabricate(:admin)
    category = Fabricate(:category)
    image_url = "../../app/assets/images/rails.png"
    sign_in(admin)
    click_link "Video Additions"
    fill_in "Title", with: "Rio"
    select category.name, from: 'Category'
    fill_in "Description", with: "This movie is for the birds."
    attach_file  "video_large_cover", 'spec/support/uploads/rio_large.jpg'
    attach_file  "video_small_cover", 'spec/support/uploads/rio_small.jpg'
    fill_in "Video Url", with: 'www.movie_url.com'
    click_on "Add Video"
    expect(page).to have_content("Video successfully added.")
    sign_out

    sign_in
    click_link "Rio"
    expect(page).to have_css 'h3', text: "Rio"
    expect(page).to have_selector 'img[src="/uploads/video/large_cover/1/rio_large.jpg"]'
    expect(page).to have_selector 'a[href="www.movie_url.com"]'
  end
end
