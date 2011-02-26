# coding: utf-8

class Tag
  include Mongoid::Document
  include Mongoid::Timestamps

  field :user_id, :type => BSON::ObjectId
  field :name
  field :phonetic_name
  field :about

  references_many :bookmarks, :stored_as => :array, :inverse_of => :tags
  referenced_in :user

  attr_accessible :user_id, :name, :phonetic_name, :about

  validates_length_of :name, :maximum => 32
  validates_length_of :phonetic_name, :maximum => 32
  validates_length_of :about, :maximum => 150
  validates_presence_of :user_id
  validates_presence_of :name

  scope :tags_in, lambda {|t| where(:name => t)}


  def self.autocompleted(user)
    where(:user_id => user.id, :bookmark_ids.ne => []).only(:name, :phonetic_name)
  end
end
