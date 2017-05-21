require 'rails_helper'

RSpec.describe "Companies", type: :request do

  describe "authentication" do
    context "only when access_token is valid" do
      it "gives access" do

        company1 = Company.create(access_token: "ac3b5afd-cca6-4ed6-aabb-0169e29237ad")

        get "/companies", :headers => {"HTTP_ACCESS_TOKEN" => "ac3b5afd-cca6-4ed6-aabb-0169e29237ad"}
        expect(response).to have_http_status 200

        get "/companies", :headers => {"HTTP_ACCESS_TOKEN" => "krokodyl"}
        expect(response).to have_http_status 401

        get "/companies"
        expect(response).to have_http_status 401

      end
    end
  end

  describe "GET /companies" do
    it "lists all companies" do

      company1 = Company.create(access_token: "ac3b5afd-cca6-4ed6-aabb-0169e29237ad")

      get "/companies", :headers => {"HTTP_ACCESS_TOKEN" => "ac3b5afd-cca6-4ed6-aabb-0169e29237ad"}
      expect(response).to have_http_status(200)
      expect(assigns(:companies)).to eq Company.all
    end
  end
end