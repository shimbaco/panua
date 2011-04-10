# coding: utf-8

require 'spec_helper'

describe Settings::ServicesController do
#  let(:controller) { Settings::ServicesController.new }
  let(:user) { Factory.create(:user) }
  let(:dummy_get_request_token) {
    {:request_options => {:oauth_callback => 'http://test.host/settings/services/hatena/create'},
     :arguments => {:scope => 'read_public,write_public,write_private'}} }
  let(:dummy_request_token) {
    {:token => 'dummy_request_token',
     :secret => 'dummy_request_token_secret',
     :authorize_url => 'http://example.com/oauth/authorize?oauth_token=dummy_oauth_token'} }
  let(:dummy_access_token) {
    {:token => 'dummy_access_token',
     :secret => 'dummy_access_token_secret'} }

  before do
    user.confirm!
    sign_in user

    # Consumer mock
    #consumer = mock(OAuth::Consumer)
    #consumer.stub!(:get_request_token).with(dummy_get_request_token[:request_options],
                                            #dummy_get_request_token[:arguments])
                                      #.and_return(double :request_token, dummy_request_token)
    #OAuth::Consumer.stub!(:new).with(
        #ApplicationSettings.oauth_keys.hatena.consumer_key,
        #ApplicationSettings.oauth_keys.hatena.consumer_secret,
        #:site               => '',
        #:request_token_path => 'https://www.hatena.com/oauth/initiate',
        #:access_token_path  => 'https://www.hatena.com/oauth/token',
        #:authorize_path     => 'https://www.hatena.ne.jp/oauth/authorize').and_return(consumer)

    ## RequestToken mock
    #request_token = mock(OAuth::RequestToken)
    #request_token.stub!(:get_access_token).with({}, :oauth_verifier => 'dummy_oauth_verifier')
                                          #.and_return(double :access_token, dummy_access_token)
    #OAuth::RequestToken.stub!(:new).with(consumer, dummy_request_token[:token], dummy_request_token[:secret])
                                   #.and_return(request_token)

    ## AccessToken mock
    #access_token = mock(OAuth::AccessToken)
    #access_token.stub!(:request).with(:get, 'http://n.hatena.com/applications/my.json')
                                #.and_return(double :request, :body => JSON.generate({'url_name' => 'bojovs'}))
    #access_token2 = OAuth::RequestToken.new(consumer, dummy_request_token[:token], dummy_request_token[:secret])
                                       #.get_access_token({}, :oauth_verifier => 'dummy_oauth_verifier')
    #OAuth::AccessToken.stub!(:new).with(consumer, access_token2.token, access_token2.secret)
                                  #.and_return(access_token)
  end

  describe '#new' do
    #it 'redirects to authorize page' do
      #get :new, {:provider_name => 'hatena'}
      #response.should redirect_to 'http://example.com/oauth/authorize?oauth_token=dummy_oauth_token'
    #end
  end

  describe '#create' do
    #it 'redirects to settings/services page' do
      #session[:request_token] = 'dummy_request_token'
      #session[:request_token_secret] = 'dummy_request_token_secret'
      #get :create, {:oauth_verifier => 'dummy_oauth_verifier', :provider_name => 'hatena'}
      #response.should redirect_to settings_services_path
    #end
  end

  describe '#request_token' do
#    let(:provider_name) { 'hatena' }
#    let(:url) { 'http://localhost:3000/' }
#
#    before do
#      @controller = Settings::ServicesController.new
#    end
#
#    it 'returns a request token' do
#      @controller.send(:request_token, provider_name, url).present?.should be_true
#    end
  end

  describe '#access_token' do
    
#    it 'returns a request token' do
#      controller.send(:request_token, provider_name, www_root).present?.should be_true
#    end
  end
end
