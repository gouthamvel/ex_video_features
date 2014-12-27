require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe VideosController, :type => :controller do

  # This should return the minimal set of attributes required to create a valid
  # Video. As you add validations to Video, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
      {title: "title 1", video_url: "//dax-video-app-local.s3.amazonaws.com/uploads/48b../file.avi", user: @user}
  }
  let(:valid_array_attributes) {
    [
      {title: "title 1", video_url: "//dax-video-app-local.s3.amazonaws.com/uploads/48b../file.avi", user: @user}
    ]
  }

  let(:invalid_array_attributes) {
    [{title: "title 1", video_url: nil}]
  }
  let(:invalid_attributes) {
    {title: "title 1", video_url: nil}
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # VideosController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  before(:all) do
    @user = FactoryGirl.create(:user)
  end

  before (:each) do
    sign_in @user
  end

  describe "GET index" do
    it "assigns all videos as @videos" do
      video = Video.create! valid_array_attributes
      get :index, {}
      expect(response).to have_http_status(:success)
      expect(assigns(:videos)).to eq(video)
    end
  end

  describe "GET show" do
    it "assigns the requested video as @video" do
      video = Video.create! valid_array_attributes
      get :show, {user_id: @user.id, id: video.to_param}, valid_session
      expect(assigns(:videos)).to eq(video)
    end
  end

  describe "GET new" do
    it "assigns a new video as @video" do
      get :new, {user_id: @user.id}, valid_session
      expect(assigns(:video)).to be_a_new(Video)
    end
  end

  describe "GET edit" do
    it "assigns the requested video as @video" do
      video = Video.create! valid_array_attributes
      get :edit, {user_id: @user.id, id: video.to_param}, valid_session
      expect(assigns(:video)).to eq(video.first)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Video" do
        expect {
          post :create, {user_id: @user.id, video: valid_array_attributes}, valid_session
        }.to change(Video, :count).by(1)
      end

      it "assigns a newly created video as @video" do
        post :create, {user_id: @user.id, video: valid_array_attributes}, valid_session
        expect(assigns(:videos)).to be_a(Array)
        expect(assigns(:videos).first).to be_persisted
      end

      it "redirects to the created video" do
        post :create, {user_id: @user.id, video: valid_array_attributes}, valid_session
        expect(response).to redirect_to(user_videos_path(@user))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved video as @video" do
        post :create, {user_id: @user.id, video: invalid_array_attributes}, valid_session
        expect(assigns(:videos)).to be_a(Array)
        expect(assigns(:videos).first).to be_a_new(Video)
      end

      it "re-renders the 'new' template" do
        post :create, {user_id: @user.id, video: invalid_array_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested video" do
        video = Video.create! valid_attributes
        put :update, {user_id: @user.id, id: video.to_param, :video => new_attributes}, valid_session
        video.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested video as @video" do
        video = Video.create! valid_attributes
        put :update, {user_id: @user.id, id: video.to_param, :video => valid_attributes}, valid_session
        expect(assigns(:video)).to eq(video)
      end

      it "redirects to the video" do
        video = Video.create! valid_attributes
        put :update, {user_id: @user.id, id: video.to_param, :video => valid_attributes}, valid_session
        expect(response).to redirect_to(user_video_path(@user, video))
      end
    end

    describe "with invalid params" do
      it "assigns the video as @video" do
        video = Video.create! valid_attributes
        put :update, {user_id: @user.id, id: video.to_param, :video => invalid_attributes}, valid_session
        expect(assigns(:video)).to eq(video)
      end

      it "re-renders the 'edit' template" do
        video = Video.create! valid_attributes
        put :update, {user_id: @user.id, id: video.to_param, :video => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested video" do
      video = Video.create! valid_attributes
      expect {
        delete :destroy, {user_id: @user.id, id: video.to_param}, valid_session
      }.to change(Video, :count).by(-1)
    end

    it "redirects to the videos list" do
      video = Video.create! valid_attributes
      delete :destroy, {user_id: @user.id, id: video.to_param}, valid_session
      expect(response).to redirect_to(user_videos_path(@user))
    end
  end

end
