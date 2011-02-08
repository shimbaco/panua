# coding: utf-8

class Settings::TagsController < ApplicationController
  before_filter :authenticate_user!

  respond_to :html

  def index
    @tags = Tag.where(:user_id => current_user.id).asc(:name)
  end

  def edit
    @tag = Tag.find(params[:id])
    redirect_to home_path if @tag.user_id != current_user.id
  end

  def update
    @tag = Tag.criteria.id(params[:id]).first
    @tag.update_attributes(params[:tag])
    flash[:notice] = 'saved'
    redirect_to settings_tags_path
  end
end
