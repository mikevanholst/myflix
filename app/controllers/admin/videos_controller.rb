class Admin::VideosController < AdminController

  def new  
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    if @video.save
      flash[:success] = "Video successfully added."
      redirect_to new_admin_video_path
    else
      flash.now[:error] = "There was a problem adding your video."
      render :new
    end
  end

private

  def  video_params
    params.require(:video).permit(:title, :description, :category_id, :small_cover, :large_cover)
 end


end