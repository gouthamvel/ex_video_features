class Video < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :video_url, message: "can't be blank"
  validates_presence_of :title, message: "can't be blank"
  validates_associated :user
end
