class CatchAllController < AuthenticatedController

  def index
    video = Video.find(:first, :conditions => ["title LIKE ?", "#{params[:path].first}%"])
    redirect_to video_path(video)
  end

end