# coding: utf-8

class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:profile]

  def home
    following_ids = User.criteria.id(current_user.id).first.following_ids
    @bookmarks = Bookmark.any_in(:user_id => following_ids).where(:private => false).desc(:created_at).paginate(:per_page => 30, :page => params[:page])
  end

  def profile
    @user = User.where(:screen_name => params[:screen_name]).first
    if @user.blank?
      return render_404
    end
    if params[:tags].blank? # '/:screen_name/tags/*tags'
      @bookmarks = @user.bookmarks
    else
      tag_ids = Tag.where(:user_id => @user.id).any_in(:name => params[:tags].split('/')).only(:_id).map(&:_id)
      @bookmarks = Bookmark.all_in(:tag_ids => tag_ids)
    end
    @bookmarks = @bookmarks.where(:private => false) if current_user != @user
    @bookmarks_count = @bookmarks.count
    @bookmarks = @bookmarks.desc(:created_at).paginate(:per_page => 30, :page => params[:page])
    @tags = Tag.where(:user_id => @user.id, :bookmark_ids.ne => []).asc(:name)
  end

  def follow
    @user = User.criteria.id(params[:id]).first
    current_user.following << @user
    current_user.save
    render :nothing => true
  end

  def remove
    @user = User.criteria.id(params[:id]).first
    current_user.following_ids.delete(@user.id)
    @user.follower_ids.delete(current_user.id)
    current_user.save
    @user.save
    render :nothing => true
  end

  def following_followers
    @user = User.where(:screen_name => params[:screen_name]).first
    if @user.blank?
      return render_404
    end
    (params[:follow] == 'following') ? render('following') : render('followers')
  end
end
