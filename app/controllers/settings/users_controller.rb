# coding: utf-8

class Settings::UsersController < ApplicationController
  before_filter :authenticate_user!

  def edit
    @user = User.criteria.id(current_user.id).first
  end

  def update
    @user = User.criteria.id(current_user.id).first
    @user.update_attributes(params[:user])
    flash[:notice] = t('panua.words.saved')
    redirect_to profile_path(current_user.screen_name)
  end
end
