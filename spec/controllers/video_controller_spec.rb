require 'rails_helper'

RSpec.describe VideoController, :type => :controller do

  describe "GET index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:found)
      expect(response.body).to include("redirected")
    end
  end

end
