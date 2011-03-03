# coding: utf-8

require 'spec_helper'

describe BookmarksController do

  before do
    @user = Factory.create(:user)
    @user.confirm!
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
    let(:bookmark1) { {:url => 'http://example.com/1', :title => 'example1'} }
    let(:bookmark2) { {:url => 'http://example.com/2', :title => 'example2'} }

    context 'valid' do
      let(:entry) { Factory.create(:entry, :url => 'http://example.com/1', :title => 'example1') }
      let(:params1) { {:bookmark => bookmark1, :tag_name => 'hoge, fuga', :comment_body => 'comment1'} }
      let(:params2) { {:bookmark => bookmark2, :tag_name => 'foo, bar', :comment_body => 'comment2'} }
      let(:comment) { Factory.create(:comment, :user_id => @user.id, :entry_id => entry.id) }

      it 'saves a bookmark' do
        post :create, params1
        Bookmark.all.count.should == 1
      end

      it 'saves 2 tags' do
        post :create, params1
        bookmark = Bookmark.where(:user_id => @user.id, :url => bookmark1[:url]).first
        bookmark.tags.count.should == 2
      end

      it 'saves a comment' do
        post :create, params1
        entry = Entry.where(:url => bookmark1[:url]).first
        entry.comments.count.should == 1
      end

      it 'saves a new entry' do
        post :create, params2
        entry = Entry.where(:url => bookmark2[:url]).first
        entry.present?.should be_true
      end

      it 'saves a relation between bookmark and entry' do
        entry
        post :create, params1
        entry.reload.bookmarks.count.should == 1
      end

      it 'saves bookmark_id in comment which bookmark was removed' do
        comment
        post :create, params1
        comment.reload.bookmark_id.present?.should be_true
      end

      it 'redirects to home_path' do
        post :create, params1
        response.should redirect_to home_path
      end
    end

    context 'invalid' do
      before do
        @bookmark = Factory.create(:bookmark, :url => 'http://example.com/1')
        @user.bookmarks << @bookmark
      end

      it 'redirects to #edit if bookmark is already saved' do
        post :create, :bookmark => bookmark1
        response.should redirect_to edit_bookmark_path(:id => @bookmark.id)
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

  describe '#destroy' do
    let(:entry) { Factory.create(:entry) }
    let(:bookmark1) { Factory.create(:bookmark) }
    let(:bookmark2) { Factory.create(:bookmark, :user_id => BSON::ObjectId.from_string('aaaaaaaaaaaaaaaaaaaaaaaa')) }

    before do
      entry.bookmarks << bookmark1
      entry.bookmarks << bookmark2
    end

    context 'valid bookmark.id' do
      before do
        @user.bookmarks << bookmark1
        delete :destroy, {:id => bookmark1.id.to_s}
      end
      
      it 'returns 200' do
        response.code.should == '200'
      end
    end

    context 'invalid bookmark.id' do
      it 'returns 400 when bookmark_id is not existed' do
        delete :destroy, {:id => 'bbbbbbbbbbbbbbbbbbbbbbbb'}
        response.code.should == '400'
      end

      it 'returns 400 when bookmark is not mine' do
        delete :destroy, {:id => bookmark2.id.to_s}
        response.code.should == '400'
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
