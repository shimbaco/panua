# coding: utf-8

require 'spec_helper'

describe BookmarksController do

  before do
    @user = Factory.create(:user)
    sign_in @user
  end

  describe '#new' do
    it 'should render application layout normally' do
      get :new
      response.should render_template('layouts/application')
    end

    it 'should render bookmarklet layout when params[url] is presenting' do
      get :new, :url => 'http://twitter.com/bojovs'
      response.should render_template('layouts/bookmarklet')
    end

    it 'should redirect edit action' do
      @bookmark = Factory.create(:bookmark)
      @user.bookmarks << @bookmark
      get :new, :url => 'http://twitter.com/bojovs'
      response.should redirect_to edit_bookmark_path(:id => @bookmark.id) + '?bookmarklet=true'
    end
  end

  describe '#create' do
    let(:bookmark1) {
      {:url => 'http://twitter.com/bojovs',
       :title => 'bojovs::twitter'}
    }
    let(:bookmark2) {
      {:url => 'http://www.google.com/profiles/bojovs',
       :title => 'bojovs::Google Profile'}
    }

    before do
      @bookmark = Factory.create(:bookmark)
      @user.bookmarks << @bookmark
    end

    it 'redirects to #edit if bookmark is already saved' do
      post :create, :bookmark => bookmark1
      response.should redirect_to edit_bookmark_path(:id => @bookmark.id)
    end

    context 'creates bookmark, tags, comment' do
      let(:params) {{:bookmark => bookmark2, :tag_name => 'hoge, fuga', :comment_body => 'comment.'}}

      before do
        post :create, params
      end

      it 'should save bookmark' do
        Bookmark.all.count.should == 2
      end

      it 'should have 2 tags' do
        b = Bookmark.where(:user_id => @user.id, :url => bookmark2[:url]).first
        b.tags.count.should == 2
      end

      it 'should save comment' do
        e = Entry.where(:url => bookmark2[:url]).first
        e.comments.count.should == 1
      end

      it 'redirects to home_path' do
        response.should redirect_to home_path
      end
    end
  end

  describe '#edit' do
    before do
      @bookmark = Factory.create(:bookmark)
    end

    it 'should redirect home_path' do
      get :edit, :id => @bookmark.id, :bookmarklet => 'true'
      response.should redirect_to home_path
    end

    it 'should render bookmarklet layout' do
      @user.bookmarks << @bookmark
      get :edit, :id => @bookmark.id, :bookmarklet => 'true'
      response.should render_template('layouts/bookmarklet')
    end
  end

  describe '#update' do
    before do
      @bookmark = Factory.create(:bookmark)
      @bookmark_params = {:id => @bookmark.id,
                          :bookmark => {:url => 'http://twitter.com/bojovs', :title => 'bojovs twitter'},
                          :old_tag_name => 'hoge, fuga',
                          :tag_name => 'moge'}
    end

    context 'invalid' do
      it 'redirects to home_path when current_user is not the bookmark owner'  do
        put :update, @bookmark_params
        response.should redirect_to home_path
      end
    end

    context 'valid' do
      before do
        @user.bookmarks << @bookmark
      end

      it 'redirect to profile_path' do
        put :update, @bookmark_params
        response.should redirect_to profile_path(@user.screen_name)
      end

      it 'render bsaved template' do
        put :update, @bookmark_params.merge({:bookmarklet => 'true'})
        response.should render_template('bsaved')
      end

      it 'updates title' do
        put :update, @bookmark_params
        bookmark = Bookmark.where(:url => 'http://twitter.com/bojovs').first
        bookmark.title.should == 'bojovs twitter'
      end
    end
  end

  describe '#split_tag_str' do
    before do
      @controller = BookmarksController.new
    end

    it 'splits tag 1' do
      tag_str = 'hoge, fuga, moge'
      @controller.send(:split_tag_str, tag_str).should == ['hoge', 'fuga', 'moge']
    end

    it 'splits tag 2' do
      tag_str = 'hoge ,  fuga, moge '
      @controller.send(:split_tag_str, tag_str).should == ['hoge', 'fuga', 'moge']
    end

    it 'splits tag 3' do
      tag_str = ',hoge ,  fuga, moge, '
      @controller.send(:split_tag_str, tag_str).should == ['hoge', 'fuga', 'moge']
    end
  end

  describe '#tags_to_str' do
    before do
      Factory.create(:tag, :name => 'hoge')
      Factory.create(:tag, :name => 'fuga')
      Factory.create(:tag, :name => 'moge')
    end

    it 'should return str' do
      @tags = Tag.all
      @controller = BookmarksController.new
      @controller.send(:tags_to_str, @tags).should == 'hoge, fuga, moge'
    end
  end

  describe '#page_title' do
    before do
      @controller = BookmarksController.new
    end

    it 'return page title' do
      @controller.send(:page_title, 'http://www.google.com/').should == 'Google'
    end

    it 'return error title when URL is wrong' do
      @controller.send(:page_title, 'http://nonexistentdomainnonexistentdomain.com/').should == 'no title'
    end
  end
end
