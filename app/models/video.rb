class Video < ActiveRecord::Base
  belongs_to :user
  has_many :comments, dependent: :destroy

  validates_presence_of :video_url, message: "can't be blank"
  validates_presence_of :title, message: "can't be blank"
  validates_associated :user

  JSON_INCLUDE = {only: [:id, :title], methods:[:authenticated_url, :type, :markers], include: {user: {only: [:email]} }}

  def static_local_url
    name = video_url.gsub /\/\/#{ENV['S3_BUCKET']}.s3.amazonaws.com\/uploads\/.*\/(.*)/, "\\1"
    "/assets/uploads/#{name}"
  end

  def authenticated_url
    # return static_local_url if ENV['LOCAL_VIDEO']
    object = S3_BUCKET.objects[video_url.gsub "//#{ENV["S3_BUCKET"]}.s3.amazonaws.com/", ""]
    object.url_for(:get, { :expires => 20.minutes.from_now, :secure => true }).to_s
  end

  def markers
    comments.order("created_at desc").as_json(Comment::JSON_MARKER_INCLUDE)
  end

  def type
    video_url.match(/.*\.(.*)$/)[1]
  end

end
