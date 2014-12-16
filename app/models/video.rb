class Video < ActiveRecord::Base
  belongs_to :user
  has_many :comments, dependent: :destroy

  validates_presence_of :video_url, message: "can't be blank"
  validates_presence_of :title, message: "can't be blank"
  validates_associated :user

  def authenticated_url
    object = S3_BUCKET.objects[video_url.gsub "//dax-video-app-local.s3.amazonaws.com/", ""]
    object.url_for(:get, { :expires => 20.minutes.from_now, :secure => true }).to_s
  end

  def markers
    hash = comments.as_json(Comment::JSON_MARKER_INCLUDE)
    hash.map do |c|
      c[:text] = c["content"]
      c
    end
  end

end
