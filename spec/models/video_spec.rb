require 'spec_helper'

describe Video do
  it {should validate_presence_of(:title)}
  it {should validate_presence_of(:description)}
  it {should belong_to(:category)}
  it {should have_many(:queue_items)}

  describe "#search_by_title" do
    
    it "returns an empty array when there are no matches" do
      expect(Video.search_by_title('Hello')).to eq([])
    end
    it "returns an array of one for a single match " do
      animated = Category.create(name: 'Animated')
      up = Video.create(title: 'Up', description: 'Good', category: animated) 
      expect(Video.search_by_title('Up')).to eq([up])
    end
    it "returns an array of partial matches " do
      animated = Category.create(name: 'Animated')
      pup = Video.create(title: 'Pup', description: 'Good', category: animated) 
      up = Video.create(title: 'Up', description: 'Good', category: animated) 
      down = Video.create(title: 'Down', description: 'Bad', category: animated) 
      expect(Video.search_by_title('Up')).to eq([up,pup])
    end
    it "orders matches by exactness"
    end

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
end
