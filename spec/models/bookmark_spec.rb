# coding: utf-8

require 'spec_helper'

describe Bookmark do

  describe 'validation' do
    it 'is not valid when note is over 150 characters' do
      status = Factory.build(:bookmark, :note => "t#{'o'*100} l#{'o'*50}ng!!!")
      status.should_not be_valid
    end

    it 'is not valid when url is blank' do
      status = Factory.build(:bookmark, :url => '')
      status.should_not be_valid
    end

    it 'is not valid when title is blank' do
      status = Factory.build(:bookmark, :title => '')
      status.should_not be_valid
    end
  end

  describe '#add_tags!' do
    let(:user) { Factory.create(:user) }
    let(:bookmark) { Factory.create(:bookmark) }

    before do
      Factory.create(:tag, :user_id => user.id, :name => 'tag1')
      Factory.create(:tag, :user_id => user.id, :name => 'tag2')
      bookmark.add_tags!(['tag1', 'fuga'], user.id)
    end

    it 'should save tags' do
      bookmark.tags.count.should == 2
    end

    it 'should increase tags' do
      Tag.all.count.should == 3
    end
  end

  describe '#remove_tags!' do
    let(:user) { Factory.create(:user) }
    let(:bookmark) { Factory.create(:bookmark) }
    let(:tag1) { Factory.create(:tag, :user_id => user.id, :name => 'hoge') }
    let(:tag2) { Factory.create(:tag, :user_id => user.id, :name => 'fuga') }
    let(:tag3) { Factory.create(:tag, :user_id => user.id, :name => 'moge') }

    before do
      bookmark.tags << tag1
      bookmark.tags << tag2
      bookmark.tags << tag3
      bookmark.remove_tags!(['hoge', 'moge'], user.id)
    end

    it 'should delete bookmark.tag_ids' do
      bookmark.tag_ids.count.should == 1
    end

    it 'should remain Tag data' do # phonetic_nameやaboutのデータを残すため、Tag内のデータは消さずに残しておく
      bookmark.tags.count.should == 3
    end

    it 'should delete tag.bookmark_id' do
      tag = Tag.where(:name => 'moge').first
      tag.bookmark_ids.count.should == 0
    end
  end

  describe '#reconnect_to_comments!' do
    let(:user) { Factory.create(:user) }
    let(:entry) { Factory.create(:entry) }
    let(:bookmark) { Factory.create(:bookmark) }
    let(:comment) { Factory.create(:comment, :body => 'comment', :user_id => user.id, :entry_id => entry.id, :bookmark_id => nil) }

    before do
      comment
      bookmark.reconnect_to_comments!(user, entry)
    end

    it 'saves bookmark_id' do
      comment.reload.bookmark_id.should == bookmark.id
    end

    it 'saves comment_ids in bookmark' do
      bookmark.comments.count.should == 1
    end
  end
end
