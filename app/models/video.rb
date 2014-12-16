class Video < ActiveRecord::Base
  belongs_to :user
  has_many :comments

  validates_presence_of :video_url, message: "can't be blank"
  validates_presence_of :title, message: "can't be blank"
  validates_associated :user

  def markers
    hash = comments.as_json(Comment::JSON_MARKER_INCLUDE)
    hash.map do |c|
      c[:text] = c["content"]
      c
    end
  end

end
