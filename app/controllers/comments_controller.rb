class CommentsController < ApplicationController
  before_action :authenticate_user!

  respond_to :html, :js

  def create
    @video = Video.find(params[:video_id])
    comment = @video.comments.create(comment_params)
    comment.user = current_user
    if comment.save
      respond_with({success: true})
    else
      raise "Error"
    end
  end

private
  def comment_params
    params.require(:comment).permit(:content, :time)
  end

end
