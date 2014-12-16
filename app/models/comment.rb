class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates_presence_of :time
  validates_associated :video
  validates_associated :user

  JSON_INCLUDE = {only: [:id, :video_id, :content, :time, :created_at], include: {user: {only: [:email, :created_at]}}}
  JSON_MARKER_INCLUDE = {only: [:content, :time], include: {user: {only: [:email]}}}

  def marker
    c = as_json(Comment::JSON_MARKER_INCLUDE)
    c[:text] = c["content"]
    c
  end

end
