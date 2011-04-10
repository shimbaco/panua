# coding: utf-8

require 'oauth'

class Service
  include Mongoid::Document
  include Mongoid::Timestamps

  field :provider_name
  field :access_token
  field :access_secret
  field :nickname

  referenced_in :user

  validates_presence_of :provider_name
  validates_presence_of :access_token
  validates_presence_of :access_secret
  validates_presence_of :nickname


  def self.hatena_consumer
    OAuth::Consumer.new(
      ApplicationSettings.oauth_keys.hatena.consumer_key,
      ApplicationSettings.oauth_keys.hatena.consumer_secret,
      :site               => '',
      :request_token_path => 'https://www.hatena.com/oauth/initiate',
      :access_token_path  => 'https://www.hatena.com/oauth/token',
      :authorize_path     => 'https://www.hatena.ne.jp/oauth/authorize')
  end
end
