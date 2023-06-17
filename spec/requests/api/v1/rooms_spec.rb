require "rails_helper"

RSpec.describe "Api::V1::Rooms", type: :request do
  before { host! "messeger-fractal.com.br" }
  before { @app = create(:app) }
  let(:admin) { create(:user, :admin, name: "Reginaldo Perine") }
  let(:token) { JwtAuth::TokenProvider.issue_token({ email: admin.email, fractal_id: admin.fractal_id }) }
  let(:headers) do
    {
      "Accept" => "application/vnd.messeger-fractal.v1",
      "Content-Type" => Mime[:json].to_s,
      "Authorization" => "Bearer #{token}"
    }
  end

  describe "GET /index" do
    let!(:rooms) { create_list(:room, 5, app: @app) }
    before { get "/api/apps/#{@app.id}/rooms", params: {}, headers: }

    context "successfully" do
      it "returns status code success" do
        expect(response).to have_http_status(:success)
      end

      it "returns a list of rooms" do
        expect(json_body[:data].count).to eq(5)
      end
    end
  end

  describe "GET /show" do
    let!(:room) { create(:room, app: @app) }
    before { get "/api/rooms/#{room.id}", params: {}, headers: }

    context "successfully" do
      it "returns status code success" do
        expect(response).to have_http_status(:success)
      end

      it "returns a room" do
        expect(json_body[:data][:id]).to eq(room.id.to_s)
      end
    end

    context "when the room does not exist" do
      before { get "/api/rooms/0", params: {}, headers: }

      it "returns status code not found" do
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "POST /create" do
    before { post "/api/apps/#{@app.id}/rooms", params: { room: room_params }.to_json, headers: }

    context "successfully" do
      let(:room_params) { build(:room, app: @app) }
      it "returns status code created" do
        expect(response).to have_http_status(:created)
      end

      it "returns the created room" do
        expect(json_body[:data][:attributes][:name]).to eq(room_params[:name])
      end
    end

    context "when the room is invalid" do
      let(:room_params) { attributes_for(:room, name: nil) }

      it "returns status code unprocessable_entity" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns the json data for the errors" do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe "PUT /update" do
    let!(:room) { create(:room, app: @app) }
    before { put "/api/rooms/#{room.id}", params: { room: room_params }.to_json, headers: }

    context "successfully" do
      let(:room_params) { { name: "New name" } }

      it "returns status code success" do
        expect(response).to have_http_status(:success)
      end

      it "returns the updated room" do
        expect(json_body[:data][:attributes][:name]).to eq(room_params[:name])
      end
    end

    context "when the room does not exist" do
      before { put "/api/rooms/0", params: { room: room_params }.to_json, headers: }

      let(:room_params) { { name: "New name" } }

      it "returns status code not found" do
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when the room is invalid" do
      let(:room_params) { { name: nil } }

      it "returns status code unprocessable_entity" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns the json data for the errors" do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe "DELETE /destroy" do
    let!(:room) { create(:room, app: @app) }
    before { delete "/api/rooms/#{room.id}", params: {}, headers: }

    context "successfully" do
      it "returns status code no_content" do
        expect(response).to have_http_status(:no_content)
      end
    end

    context "when the room does not exist" do
      before { delete "/api/rooms/0", params: {}, headers: }

      it "returns status code not found" do
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when the room does not belong to the app" do
      let!(:room) { create(:room) }
      before { delete "/api/rooms/#{room.id}", params: {}, headers: }

      it "returns status code not found" do
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
