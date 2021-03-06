class VideosController < ApplicationController
  before_action :require_user

  def index
    @videos = Video.all 
  end

  def show
    @video = VideoDecorator.decorate(Video.find(params[:id]))
    #railscasts 22 suggests that eager loading with the second line should be faster but it is not.
    @reviews = @video.reviews
    # @reviews = @video.reviews.find(:all, include: :user)

    @review = Review.new
  end

  def search
    @results = Video.search_by_title(params[:search_term])
  end
        
  def edit
  end

  def new
  end
end
