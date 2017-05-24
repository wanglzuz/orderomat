module Authable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
  end

  def authenticate_user!

    token = request.headers["HTTP_ACCESS_TOKEN"]

    if token == nil
      render json: { errors: [ { detail: "No access token provided!" } ] }, status: 401  # TODO: 2)
      return
    end

    @company = Company.find_by(access_token: token)
    if @company == nil
      render json: { errors: [ { detail: "Invalid access token!" } ] }, status: 401  # TODO: 2)
    end

    # redirect_to root_path and return if current_user.nil?
    # refresh_google_token
    # must_be_with_valid_domain!
  end

  def must_be_admin!
    unauthorized! unless is_admin?
  end

  def must_be_with_valid_domain!
    return true unless Rails.configuration.x.restrict_domain_access

    if current_user.present? && current_user.role != 'admin' && !AllowedDomain.is_allowed?(current_user.email_domain)
      raise AuthorizationError.new(t('errors.messages.not_allowed_domain'))
    end
  end

  def refresh_google_token
    return true if current_user.last_activity_at.present? && current_user.last_activity_at > (DateTime.now - 15.minutes)

    current_user.refresh!
    current_user.update!(last_activity_at: DateTime.now)
  rescue Signet::AuthorizationError => e
    Airbrake.notify("#{e.message} - Probably nil value of access_token? - User ##{current_user.id} - #{current_user.inspect}")
    # current_user.update!(refresh_token: nil)
    sign_out(current_user)
    # redirect_to user_google_oauth2_omniauth_authorize_path(prompt: 'consent') and return
    raise AuthenticationError.new(t('errors.messages.session_expired'))
  end

  def is_admin?
    current_user!.role == 'admin'
  end

  def unauthorized!
    raise AuthorizationError.new
  end

  # This method raises authentication error when we do not have current user
  def current_user!
    return current_user unless current_user.nil?
    raise AuthenticationError.new
  end
end
