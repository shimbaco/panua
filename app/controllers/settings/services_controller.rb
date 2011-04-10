# coding: utf-8

class Settings::ServicesController < ApplicationController
  before_filter :authenticate_user!


  def index
    @hatena = current_user.services.where(:provider_name => 'hatena').first
  end

  def new
    @hatena = current_user.services.where(:provider_name => 'hatena').first
    return redirect_to settings_services_path if @hatena.present?
    request_token = request_token(params[:provider_name], www_root)
    session[:request_token] = request_token.token
    session[:request_token_secret] = request_token.secret
    redirect_to request_token.authorize_url
  end

  def create
    access_token = access_token(params[:oauth_verifier])

    session[:request_token] = nil
    session[:request_token_secret] = nil

    @service = current_user.build_service(params[:provider_name], access_token)
    if @service.present?
      current_user.services << @service
      flash[:notice] = t('panua.settings.services.connect.connected')
    else
      flash[:error] = t('panua.settings.services.connect.cannot_connected')
    end
    redirect_to settings_services_path
  end

  def destroy
    if current_user.remove_service(params[:provider_name])
      flash[:notice] = t('panua.settings.services.connect.stoped_connecting')
    end
    redirect_to settings_services_path
  end

  private
    def www_root
      request.protocol + request.host_with_port
    end

    def request_token(provider_name, www_root)
      consumer = Service.hatena_consumer
      request_options = {:oauth_callback => www_root + settings_create_services_path(provider_name)}
      consumer.get_request_token(request_options, :scope => 'read_public,write_public,write_private')
    end

    def access_token(oauth_verifier)
      consumer = Service.hatena_consumer
      request_token = OAuth::RequestToken.new(consumer, session[:request_token], session[:request_token_secret])
      access_token = request_token.get_access_token({}, :oauth_verifier => oauth_verifier)
      OAuth::AccessToken.new(consumer, access_token.token, access_token.secret)
    end
end
