require 'spec_helper'

describe Admin::VideosController do 
  describe "GET new"  do

    it_behaves_like "requires sign in" do
      let(:action) {get :new}
    end
    it_behaves_like "requires admin" do
      let(:action) {get :new}
    end

    it "sets the @video variable" do
      set_current_admin
      get :new
      expect(assigns(:video)).to be_new_record
      expect(assigns(:video)).to be_instance_of(Video)
    end
  end

  describe "POST create" do
    it_behaves_like "requires sign in" do
      let(:action) {get :new}
    end
    it_behaves_like "requires admin" do
      let(:action) {get :new}
    end

    context "with current_admin" do
      before {set_current_admin}
      context "posting valid inputs" do
        before { post :create, video: Fabricate.attributes_for(:video_with_category)}
        it "should redirect to the new page" do
          expect(response).to redirect_to new_admin_video_path
        end
        it "should create a new video" do
          expect(Video.count).to eq(1)
        end
        it "should set the flash message" do
          expect(flash[:success]).to be_present
        end

      end
      
      context "posting invalid inputs" do
         before { post :create, video: Fabricate.attributes_for(:video_with_category, title: nil)}
        it "should render the new template" do
          expect(response).to render_template :new
        end
        it "should not create the video" do
           expect(Video.count).to eq(0)
        end
        it "should set the error message" do
          expect(flash[:error]).to be_present
        end
        it "should persist the entries" do

          expect(assigns(:video)).to be_present
        end
      end
    end
  end
end