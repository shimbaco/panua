# coding: utf-8

require 'spec_helper'

describe Entry do
  let(:entry) { Factory.create(:entry) }

  describe 'validation' do
    it 'is not valid when url is blank' do
      status = Factory.build(:entry, :url => '')
      status.should_not be_valid
    end

    it 'is not valid when title is blank' do
      status = Factory.build(:entry, :title => '')
      status.should_not be_valid
    end
  end

  describe '.build' do
    it 'should return existing Entry' do
      entry
      e = Entry.build('http://twitter.com/bojovs', 'twitter')
      e.title.should == entry.title
    end

    it 'should return new Entry' do
      e = Entry.build('http://twitter.com/example', 'example')
      e.title.should == 'example'
    end
  end

  describe '#add_comment' do
    let(:bookmark) { Factory.create(:bookmark) }
    let(:user) { Factory.create(:user) }

    before do
      entry.add_comment('hello', user, bookmark)
    end

    it 'save comment' do
      entry.comments.count.should == 1
    end

    it 'save bookmark.comments' do
      bookmark.comments.count.should == 1
    end
  end
end
