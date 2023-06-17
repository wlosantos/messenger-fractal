require "rails_helper"

RSpec.describe "User Api", type: :request do
  before { host! "messenger-fractal.com.br" }
  let(:user) { create(:user) }
  let(:token) { JwtAuth::TokenProvider.issue_token({ email: user.email, fractal_id: user.fractal_id }) }
  let(:headers) do
    {
      "Accept" => "application/vnd.messenger-fractal.v1",
      "Content-Type" => Mime[:json].to_s,
      "Authorization" => "Bearer #{token}"
    }
  end

  describe "GET /users" do
    before do
      create_list(:user, 4)
      get "/api/users", params: {}, headers:
    end

    it "returns users" do
      expect(json_body[:data].count).to eq(5)
    end

    it "returns status code 200" do
      expect(response).to have_http_status(:success)
    end
  end
end
