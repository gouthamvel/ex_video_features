class VideosController < ApplicationController
  before_action :set_video, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  respond_to :html

  def index
    @videos = Video.all
    respond_with(@videos)
  end

  def show
    respond_with(@video)
  end

  def new
    @s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/#{SecureRandom.uuid}/${filename}", success_action_status: 201, acl: :public_read)
    @video = Video.new
    respond_with(@video)
  end

  def edit
  end

  def create
    @video = Video.new(video_params)
    @video.user = current_user
    @video.save
    respond_with(@video)
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
    def set_video
      @video = Video.find(params[:id])
      @video.user = current_user
    end

    def video_params
      params.require(:video).permit(:title, :video_url)
    end
end