# coding: utf-8

require 'spec_helper'

describe UsersController do
  let(:user1) { Factory.create(:user) }
  let(:user2) { Factory.create(:user, :email => 'hoge@example.com', :screen_name => 'hoge') }
  let(:user3) { Factory.create(:user, :email => 'fuga@example.com', :screen_name => 'fuga') }
  let(:bookmark1_1) { Factory.create(:bookmark, :url => 'http://twitter.com/bojovs1') }
  let(:bookmark1_2) { Factory.create(:bookmark, :url => 'http://twitter.com/bojovs2', :private => true) }
  let(:bookmark2_1) { Factory.create(:bookmark, :url => 'http://twitter.com/hoge1') }
  let(:bookmark2_2) { Factory.create(:bookmark, :url => 'http://twitter.com/hoge2', :private => true) }
  let(:bookmark3) { Factory.create(:bookmark, :url => 'http://twitter.com/fuga') }

  before do
    user1.confirm!
    sign_in user1
    user1.following << user2
    user1.following << user3
    user1.bookmarks << bookmark1_1
    user1.bookmarks << bookmark1_2
    user2.bookmarks << bookmark2_1
    user2.bookmarks << bookmark2_2
    user3.bookmarks << bookmark3
  end

  describe '#home' do
    it 'gets self and following bookmarks' do
      get :home
      assigns(:bookmarks).count.should == 2
    end

    it 'renders home template' do
      get :home
      response.should render_template('users/home')
    end
  end

  describe '#profile' do
    let(:tag1_1) { Factory.create(:tag, :name => 'foo', :user_id => user1.id) }
    let(:tag1_2) { Factory.create(:tag, :name => 'bar', :user_id => user1.id) }
    let(:tag2_1) { Factory.create(:tag, :name => 'buz', :user_id => user2.id) }

    before do
      bookmark1_1.tags << tag1_1
      bookmark2_1.tags << tag2_1
    end

    it 'returns responce 404 when screen_name is wrong' do
      params = {:screen_name => 'moge'}
      get :profile, params
      response.code.should == '404'
    end

    it 'can show private bookmark in my profile page' do
      params = {:screen_name => 'bojovs'}
      get :profile, params
      assigns(:bookmarks).count.should == 2
    end

    it 'can not show private bookmark in other profile page' do
      params = {:screen_name => 'hoge'}
      get :profile, params
      assigns(:bookmarks).count.should == 1
    end

    it 'shows limited bookmarks by tags' do
      params = {:screen_name => 'bojovs', :tags => 'foo'}
      get :profile, params
      assigns(:bookmarks).count.should == 1
    end

    it 'shows tags which is not empty bookmark_ids' do
      params = {:screen_name => 'bojovs'}
      get :profile, params
      assigns(:tags).count.should == 1
    end
  end

  describe '#follow' do
    let(:user4) { Factory.create(:user, :email => 'moge@example.com', :screen_name => 'moge') }

    it 'follow' do
      params = {:id => user4.id}
      post :follow, params
      user1.reload.following.count.should == 3
    end
  end

  describe '#remove' do
    let(:user4) { Factory.create(:user, :email => 'moge@example.com', :screen_name => 'moge') }

    before do
      user1.following << user4
    end

    it 'remove' do
      params = {:id => user4.id}
      delete :remove, params
      user1.reload.following.count.should == 2
    end
  end

  describe '#following_followers' do
    let(:params) { {:screen_name => 'bojovs'} }

    it 'renders following template' do
      get :following_followers, params.merge(:follow => 'following')
      response.should render_template("users/following")
    end

    it 'renders followers template' do
      get :following_followers, params.merge(:follow => 'followers')
      response.should render_template("users/followers")
    end
  end
end
