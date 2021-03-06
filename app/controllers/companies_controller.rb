class CompaniesController < ApplicationController
  before_action :authenticate

  def index

    @companies = Company.all
    render json: @companies, status: 200

  end

  def show

    to_show = Company.find(params[:id])
    render json: to_show, status: 200

  end

private
  def authenticate
    token = request.headers["HTTP_ACCESS_TOKEN"]

    if token == nil
      render json: { errors: [ { detail: "No access token provided!" } ] }, status: 401  # TODO: 2)
      return
    end

    @company = Company.find_by(access_token: token)
    if @company == nil
      render json: { errors: [ { detail: "Invalid access token!" } ] }, status: 401  # TODO: 2)
    end

  end



end
