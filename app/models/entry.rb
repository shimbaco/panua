# coding: utf-8

class Entry
  include Mongoid::Document
  include Mongoid::Timestamps

  field :url
  field :title

  index :url, :unique => true

  references_many :bookmarks, :stored_as => :array, :inverse_of => :entry
  references_many :comments, :stored_as => :array, :inverse_of => :entry

  validates_format_of :url, :with => /^(#{URI::regexp(%w(http https))})$/
  validates_presence_of :url
  validates_presence_of :title


  def self.build(url, title)
    entry = Entry.where(:url => url).first
    if entry.blank?
      entry = Entry.new(:url => url, :title => title)
    end
    entry
  end

  def add_comment(comment_body, user, bookmark)
    comments = Comment.new(:user_id => user.id, :body => comment_body)
    self.comments << comments
    bookmark.comments << comments
  end
end
