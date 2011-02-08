# coding: utf-8

class CommentsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @comment = current_user.comments.new(:body => params[:comment][:body])
    if @comment.save
      current_user.comments << @comment
      @entry = Entry.criteria.id(params[:entry_id]).first
      @entry.comments << @comment
      @bookmark = current_user.bookmarks.where(:entry_id => params[:entry_id]).first
      @bookmark.comments << @comment if @bookmark
    end
    redirect_to entry_path(params[:entry_id])
  end

  def new_child
    @parent_comment = Comment.criteria.id(params[:parent_id]).first
    if @parent_comment.blank?
      return render(:nothing => true, :status => 404)
    end
    @child_comment = Comment.new
  end

  def create_child
    @comment = Comment.new(:body => params[:comment][:body])
    if @comment.valid?
      @parent_comment = Comment.criteria.id(params[:parent_id]).first
      @child_comment = @parent_comment.children.create(:user_id => current_user.id, :body => params[:comment][:body])
      current_user.comments << @child_comment
      @entry = Entry.criteria.id(params[:entry_id]).first
      @entry.comments << @child_comment
      @bookmark = current_user.bookmarks.where(:entry_id => params[:entry_id]).first
      @bookmark.comments << @child_comment if @bookmark
      return redirect_to entry_path(params[:entry_id])
    end
    redirect_to new_child_comment_path(params[:parent_id])
  end

  def vote
    @comment = Comment.criteria.id(params[:id]).first
    if params[:type] == 'like'
      @comment.like_users << current_user
      @comment.inc(:score, 1)
    else
      @comment.dislike_users << current_user
      @comment.inc(:score, -1)
    end
    render :nothing => true
  end

  def vote_cancel
    @comment = Comment.criteria.id(params[:id]).first
    if params[:type] == 'like'
      @comment.like_user_ids.delete(current_user.id)
      @comment.inc(:score, -1)
    else
      @comment.dislike_user_ids.delete current_user.id
      @comment.inc(:score, 1)
    end
    @comment.save
    render :nothing => true
  end
end
