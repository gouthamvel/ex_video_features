class VideosController < ApplicationController
  before_action :set_video, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  respond_to :html

  def index
    @videos = Video.all.where(user: get_user).order("created_at desc")
    respond_with(@videos)
  end

  def show
    @videos = Video.all.where(user: get_user).order("created_at desc")
    respond_with(@videos)
  end

  def new
    @s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/#{SecureRandom.uuid}/${filename}", success_action_status: 201)
    @video = Video.new
    respond_with(@video)
  end

  def edit
  end

  def create
    @videos = Video.create(videos_params[:video])
    @videos.each{|v| v.user = current_user }
    @videos.each &:save
    # hack for respond_with
    respond_with(@videos.first)
  end

  def update
    @video.update(video_params)
    respond_with(@video)
  end

  def destroy
    @video.destroy
    respond_with(@video)
  end

  private

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
