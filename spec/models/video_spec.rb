require 'rails_helper'

RSpec.describe Video, :type => :model do
  describe "Video" do
    describe "static_local_url" do
      it "should return loca url" do
        v = Video.new(video_url: "//dax-video-app-local.s3.amazonaws.com/uploads/9264f628-3a26-46ab-9e25-7fbfda4c5e10/movie3.mp4.mp4")
        expect(v.static_local_url).to eq("/assets/uploads/movie3.mp4.mp4")
      end
    end
  end
end
