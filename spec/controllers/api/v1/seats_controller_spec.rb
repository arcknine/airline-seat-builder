require 'rails_helper'

RSpec.describe Api::V1::SeatsController, type: :controller do

  describe "GET #index" do
    it "returns http unprocessable_entity if params are missing" do
      get :index
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "returns http success" do
      get :index, params: {seats: '[[2,3],[3,4],[3,2],[4,3]]', passengers: 30}
      expect(response).to have_http_status(:success)
    end

    it "returns http unprocessable_entity if invalid parameters" do
      get :index, params: {seats: '[[2,3],[3,4],[3,2],[4,3]]', passengers: 'i'}
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end