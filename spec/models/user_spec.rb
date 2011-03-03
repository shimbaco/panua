# coding: utf-8

require 'spec_helper'

describe User do
  let(:user1) { Factory.create :user }
  let(:user2) { Factory.create :user, :email => 'hoge@example.com', :screen_name => 'hoge' }
  let(:user3) { Factory.create :user, :email => 'fuga@example.com', :screen_name => 'fuga' }

  describe 'validation' do
    it 'is not valid when screen_name string is reserved' do
      status = Factory.build(:user, :screen_name => 'admin')
      status.should_not be_valid
    end

    it 'is not valid when screen_name is wrong format' do
      status = Factory.build(:user, :screen_name => 'bo-jovs')
      status.should_not be_valid
    end

    it 'is not valid when name is over 32 characters' do
      status = Factory.build(:user, :name => "t#{'o'*20} l#{'o'*20}ng!!!")
      status.should_not be_valid
    end

    it 'is not valid when screen_name is over 32 characters' do
      status = Factory.build(:user, :screen_name => "t#{'o'*20} l#{'o'*20}ng!!!")
      status.should_not be_valid
    end

    it 'is not valid when bio is over 150 characters' do
      status = Factory.build(:user, :bio => "t#{'o'*100} l#{'o'*50}ng!!!")
      status.should_not be_valid
    end

    it 'is not valid when screen_name is blank' do
      status = Factory.build(:user, :screen_name => '')
      status.should_not be_valid
    end

    it 'has a unique screen_name' do
      status = Factory.build(:user, :screen_name => user1.screen_name)
      status.should_not be_valid
    end
  end

  describe '#following?' do
    before do
      user1.following << user2
    end

    it 'is following user2' do
      user1.following?(user2.id).should be_true
    end

    it 'is not following user3' do
      user1.following?(user3.id).should be_false
    end
  end

  describe '#like?' do
    let(:comment1) { Factory.create(:comment) }
    let(:comment2) { Factory.create(:comment) }

    before do
      comment1.like_users << user1
    end

    it 'returns true when user1 likes comment1' do
      user1.like?(comment1).should be_true
    end

    it 'returns false when user1 does not like comment2' do
      user1.like?(comment2).should be_false
    end
  end

  describe '#dislike?' do
    let(:comment1) { Factory.create(:comment) }
    let(:comment2) { Factory.create(:comment) }

    before do
      comment1.dislike_users << user1
    end

    it 'returns true when user1 dislikes comment1' do
      user1.dislike?(comment1).should be_true
    end

    it 'returns false when user1 does not dislike comment2' do
      user1.dislike?(comment2).should be_false
    end
  end

  describe '#gravatar_image_path' do
    it 'returns Gravatar image url' do
      user1.gravatar_image_path.should == 'http://www.gravatar.com/avatar/9d6736bf0654a8649c35db94af65de03?d=mm&s=80'
    end
  end

  describe '#remove_bookmark' do
    let(:entry) { Factory.create(:entry) }
    let(:bookmark) { Factory.create(:bookmark) }
    let(:tag) { Factory.create(:tag) }
    let(:comment) { Factory.create(:comment) }

    before do
      user1.bookmarks << bookmark
      entry.bookmarks << bookmark
      bookmark.tags << tag
      bookmark.comments << comment
      entry.comments << comment
    end

    context 'valid' do
      before do
        user1.remove_bookmark(bookmark.id.to_s)
      end

      it 'removes the bookmark' do
        Bookmark.count.should == 0
      end

      it 'removes the relation between bookmark and user' do
        user1.reload.bookmark_ids.count.should == 0
      end

      it 'removes the relation between bookmark and entry' do
        entry.reload.bookmark_ids.count.should == 0
      end

      it 'removes the relation between bookmark and tag' do
        tag.reload.bookmark_ids.count.should == 0
      end

      it 'removes the relation between bookmark and comment' do
        comment.reload.bookmark_id.should == nil
      end

      it 'remains of the tag' do
        Tag.count.should == 1
      end

      it 'remains of the comment' do
        Comment.count.should == 1
      end

      it 'remains of the relation between entry and comment' do
        entry.reload.comment_ids.count.should == 1
      end
    end

    context 'invalid' do
      it 'returns false' do
        user1.remove_bookmark('aaaaaaaaaaaaaaaaaaaaaaaa').should be_false
      end
    end
  end
end
