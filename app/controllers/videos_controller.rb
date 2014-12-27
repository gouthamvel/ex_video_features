class VideosController < ApplicationController
  before_action :set_video, only: [:show, :edit, :update, :destroy]
  before_action :set_s3_object, only: [:new, :edit, :create]
  before_action :authenticate_user!

  respond_to :html, :json

  def index
    @user_from_param = get_user
    @videos = Video.all.where(user: @user_from_param).order("created_at desc")
    respond_with(@videos)
  end

  def show
    @user_from_param = get_user
    @videos = Video.all.where(user: @user_from_param).order("created_at desc")
    respond_with(@videos)
  end

  def new
    @video = Video.new
    respond_with(@video)
  end

  def edit
  end

  def create
    @videos = current_user.videos.create(videos_params[:video])
    respond_to do |format|
      if @videos.all?{|v| v.save }
        flash[:notice] = 'Videos was successfully created.'
        format.html { redirect_to user_videos_path(current_user) }
        format.json { render json: @videos }
      else
        format.html { render action: "new" }
        format.json { render json: @videos }
      end
    end
    # respond_with(@videos)
  end

  def update
    @video.update(video_params)
    respond_with(current_user, @video)
  end

  def destroy
    @video.destroy
    respond_with(current_user, @video)
  end

  private

    def set_s3_object
      @s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/#{SecureRandom.uuid}/${filename}", success_action_status: 200)
    end

    def get_user
      params[:user_id]? User.find(params[:user_id]) : current_user
    end

    def set_video
      @video = Video.find(params[:id])
      @video.user = current_user
    end

    def video_params
      params.require(:video).permit(:title, :video_url)
    end

    def videos_params
      params.permit(video: [:title, :video_url])
    end
end
