require 'spec_helper'

describe '#average_rating' do
  context "for a video" do
    let!(:animated) {Fabricate(:category, name: "Animated")}
    let!(:pup) {Fabricate(:video, title: "Pup", description: 'Good', category: animated)}
  
    it "should return N/A if there are no ratings" do
      expect(Video.first.average_rating).to eq("N/A")
    end
    it "should return the rating of a single review" do
      review1 = Fabricate(:review, video: pup, content: "Specified Content", rating: 5)
      expect(Video.first.average_rating).to eq(5)
    end
    it "should return the mean rating for more than one review" do
      review1 = Fabricate(:review, video: pup, content: "Glowing Content", rating: 5)
      review2 = Fabricate(:review, video: pup, content: "Critical Content", rating: 4)
      expect(Video.first.average_rating).to eq(4.5)
    end
  end
end