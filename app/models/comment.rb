# coding: utf-8

class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :body
  field :score, :type => Integer, :default => 0 # 誰かがlikeしたら+1, dislikeしたら-1

  references_many :children, :stored_as => :array, :inverse_of => :parent, :class_name => 'Comment'
  references_many :like_users, :stored_as => :array, :inverse_of => :like_comments, :class_name => 'User'
  references_many :dislike_users, :stored_as => :array, :inverse_of => :dislike_comments, :class_name => 'User'
  referenced_in :parent, :class_name => 'Comment'
  referenced_in :user
  referenced_in :entry
  referenced_in :bookmark

  validates_presence_of :body
  validates_length_of :body, :maximum => 1000
end