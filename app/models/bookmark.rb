# coding: utf-8

class Bookmark
  include Mongoid::Document
  include Mongoid::Timestamps

  field :url
  field :title
  field :note
  field :private, :type => Boolean, :default => false

  references_many :comments, :stored_as => :array, :inverse_of => :bookmark
  references_many :tags, :stored_as => :array, :inverse_of => :bookmarks
  referenced_in :user
  referenced_in :entry

  attr_accessible :url, :title, :note, :private

  validates_format_of :url, :with => /^(#{URI::regexp(%w(http https))})$/
  validates_length_of :note, :maximum => 150
  validates_presence_of :url
  validates_presence_of :title


  def add_tags!(tags_name, user_id)
    tags_name.each do |name|
      tag = Tag.where(:user_id => user_id, :name => name).first
      if tag.blank?
        tag = Tag.new(:user_id => user_id, :name => name, :phonetic_name => name)
      end
      self.tags << tag
    end
  end

  def remove_tags!(tags_name, user_id)
    delete_tag_ids = Tag.where(:user_id => user_id).any_in(:name => tags_name).only(:_id).map(&:_id)
    delete_tag_ids.each do |tid|
      self.tag_ids.delete(tid)
      tag = Tag.criteria.id(tid).first
      tag.bookmark_ids.delete(self.id)
      tag.save
    end
  end
end
