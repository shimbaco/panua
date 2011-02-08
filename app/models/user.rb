# coding: utf-8

class User
  include Mongoid::Document
  include Mongoid::Timestamps

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  field :name
  field :screen_name
  field :language, :default => 'ja'
  field :url
  field :bio

  index :screen_name, :unique => true

  references_many :bookmarks, :stored_as => :array, :inverse_of => :user
  references_many :following, :stored_as => :array, :inverse_of => :followers, :class_name => 'User'
  references_many :followers, :stored_as => :array, :inverse_of => :following, :class_name => 'User'
  references_many :comments, :stored_as => :array, :inverse_of => :user
  references_many :like_comments, :stored_as => :array, :inverse_of => :like_users, :class_name => 'Comment'
  references_many :dislike_comments, :stored_as => :array, :inverse_of => :dislike_users, :class_name => 'Comment'

  # emailとscreen_name、どちらからでもログインできるように
  attr_accessor :login
  attr_accessible :email, :password, :password_confirmation, :name, :screen_name, :login, :language, :url, :bio

  validates_exclusion_of :screen_name, :in => ApplicationSettings.reserved_screen_name_list
  validates_format_of :screen_name, :with => /^[a-zA-Z0-9_]+$/
  validates_format_of :url, :with => /^(#{URI::regexp(%w(http https))})$/, :allow_blank => true
  validates_length_of :name, :maximum => 32
  validates_length_of :screen_name, :maximum => 32
  validates_length_of :bio, :maximum => 150
  validates_presence_of :screen_name
  validates_uniqueness_of :screen_name


  def following?(user_id)
    self.following_ids.include?(user_id)
  end

  def like?(comment)
    comment.like_user_ids.include?(id)
  end

  def dislike?(comment)
    comment.dislike_user_ids.include?(id)
  end

  def gravatar_image_path(size = 80)
    hash = Digest::MD5.hexdigest(email.downcase)
    params = "d=mm&s=#{size}"
    "http://www.gravatar.com/avatar/#{hash}?#{params}"
  end

  protected
    def self.find_for_database_authentication(conditions)
      value = conditions[authentication_keys.first]
      self.any_of({ :screen_name => value }, { :email => value }).first
    end
end