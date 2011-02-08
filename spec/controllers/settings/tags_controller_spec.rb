# coding: utf-8

require 'spec_helper'

describe Settings::TagsController do

  before do
    @user = Factory.create(:user)
    sign_in @user
    @tag1 = Factory.create(:tag, :user_id => @user.id, :name => 'hoge')
    @tag2 = Factory.create(:tag, :user_id => @user.id, :name => 'fuga')
    @tag3 = Factory.create(:tag, :name => 'moge')
  end

  describe '#index' do
    it 'gets 2 tags' do
      get :index
      assigns(:tags).count.should == 2
    end
  end

  describe '#edit' do
    it 'renders edit template' do
      params = {:id => @tag1.id}
      get :edit, params
      response.should render_template('tags/edit')
    end

    it 'redirects to home_path' do
      params = {:id => @tag3.id}
      get :edit, params
      response.should redirect_to home_path
    end
  end

  describe '#update' do
    it 'updates tag name' do
      params = {:id => @tag1.id, :tag => {:name => 'hogehoge'}}
      get :update, params
      @tag1.reload.name.should == 'hogehoge'
    end

    it 'does not update tag name' do
      params = {:id => @tag1.id, :tag => {:name => ''}}
      get :update, params
      @tag1.reload.name.should == 'hoge'
    end

    it 'redirects to settings_tags_path' do
      params = {:id => @tag1.id, :tag => {:name => 'hogehoge'}}
      get :update, params
      response.should redirect_to settings_tags_path
    end
  end
end
