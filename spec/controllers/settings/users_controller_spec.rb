# coding: utf-8

require 'spec_helper'

describe Settings::UsersController do

  before do
    @user = Factory.create(:user)
    @user.confirm!
    sign_in @user
  end

  describe '#edit' do
    it 'renders edit template' do
      get :edit
      response.should render_template('users/edit')
    end
  end

  describe '#update' do
    it 'updates user name' do
      params = {:user => {:name => 'bojovsbojovs'}}
      get :update, params
      @user.reload.name.should == 'bojovsbojovs'
    end

    it 'does not update user screen_name' do
      params = {:user => {:screen_name => ''}}
      get :update, params
      @user.reload.screen_name.should == 'bojovs'
    end

    it 'redirects to profile_path' do
      params = {:user => {:name => 'bojovsbojovs'}}
      get :update, params
      response.should redirect_to profile_path(@user.screen_name)
    end
  end
end
