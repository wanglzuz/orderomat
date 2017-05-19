class CompaniesController < ApplicationController
  before_action :authenticate

  def index
    if @company == nil
      return
    end
    render json: {}, status: 200

  end

  private
  def authenticate
    authenticate_with_http_token do |token, options|

      @company = Company.find_by(access_token: token)
      if @company == nil
        puts "Company is nil.\n"
        render json: { errors: [ { detail: "Access denied" } ] }, status: 401  # TODO: 2)
      else
        puts @company.name
      end
    end
  end

end
