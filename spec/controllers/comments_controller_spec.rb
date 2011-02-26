# coding: utf-8

require 'spec_helper'

describe CommentsController do
  let(:user) { Factory.create(:user) }
  let(:entry) { Factory.create(:entry) }
  let(:bookmark) { Factory.create(:bookmark) }

  before do
    user.confirm!
    sign_in user
  end

  describe '#create' do
    it 'redirects to entry_path when comment body is empty' do
      params = {:entry_id => entry.id, :comment => {:body =>''}}
      post :create, params
      response.should redirect_to entry_path(:id => entry.id)
    end

    context 'valid' do
      let(:params) { {:entry_id => entry.id, :comment => {:body =>'コメント本文'}} }

      before do
        user.bookmarks << bookmark
        entry.bookmarks << bookmark
      end

      it 'redirects to entry_path' do
        post :create, params
        response.should redirect_to entry_path(:id => entry.id)
      end

      it 'save comment' do
        post :create, params
        Comment.all.count.should == 1
      end

      it 'save user.comments' do
        post :create, params
        user.reload.comments.count.should == 1
      end

      it 'save bookmark.comments' do
        post :create, params
        bookmark.reload.comments.count.should == 1
      end
    end
  end

  describe '#new_child' do
    it 'posts no child comment' do
      params = {:parent_id => 'aaaaaaaaaaaaaaaaaaaaaaaa'}
      get :new_child, params
      response.code.should == '404'
    end
  end

  describe '#create_child' do
    let(:parent_comment) { Factory.create(:comment, :body => '親コメント') }

    before do
      user.comments << parent_comment
      entry.comments << parent_comment
    end

    context 'valid' do
      before do
        user.bookmarks << bookmark
        entry.bookmarks << bookmark
        params = {:entry_id => entry.id, :parent_id => parent_comment.id, :comment => {:body =>'コメント本文'}}
        post :create_child, params
      end

      it 'save comment.children' do
        Comment.where(:parent_id => parent_comment.id).count.should == 1
      end

      it 'save user.comments' do
        user.reload.comments.count.should == 2
      end

      it 'save entry.comments' do
        entry.reload.comments.count.should == 2
      end

      it 'save bookmark.comments' do
        Bookmark.criteria.id(bookmark.id).first.comments.count.should == 1
      end

      it 'redirect to entry path' do
        response.should redirect_to entry_path(:id => entry.id)
      end
    end

    context 'invalid' do
      it 'redirects to new_child_comment_path' do
        params = {:entry_id => entry.id, :parent_id => parent_comment.id, :comment => {:body =>''}}
        post :create_child, params
        response.should redirect_to new_child_comment_path(:parent_id => parent_comment.id)
      end
    end
  end

  describe '#vote' do
    let(:comment) { Factory.create(:comment) }
    let(:params) { {:id => comment.id} }

    context 'like' do
      before do
        post :vote, params.merge(:type => 'like')
      end

      it 'saves comment.like_users' do
        comment.reload.like_users.count.should == 1
      end

      it 'increments comment score' do
        comment.reload.score.should == 1
      end
    end

    context 'dislike' do
      before do
        post :vote, params.merge(:type => 'dislike')
      end

      it 'saves comment.dislike_users' do
        comment.reload.dislike_users.count.should == 1
      end

      it 'decrements comment score' do
        comment.reload.score.should == -1
      end
    end
  end

  describe '#vote_cancel' do
    let(:comment) { Factory.create(:comment) }
    let(:params) { {:id => comment.id} }

    before do
      comment.like_users << user
      comment.dislike_users << user
    end

    context 'like' do
      before do
        delete :vote_cancel, params.merge(:type => 'like')
      end

      it 'deletes comment.like_user_ids' do
        comment.reload.like_user_ids.count.should == 0
      end

      it 'decrements comment score' do
        comment.reload.score.should == -1
      end
    end

    context 'dislike' do
      before do
        delete :vote_cancel, params.merge(:type => 'dislike')
      end

      it 'deletes comment.dislike_user_ids' do
        comment.reload.dislike_users.count.should == 0
      end

      it 'increments comment score' do
        comment.reload.score.should == 1
      end
    end
  end
end
