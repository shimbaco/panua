# coding: utf-8

require 'spec_helper'

describe ApplicationHelper do

  describe '#page_title' do
    it 'returns a default title' do
      helper.page_title.should == 'Panua'
    end

    it 'returns a combined title' do
      helper.page_title('welcome!').should == 'welcome! | Panua'
    end
  end

  describe 'little_time_ago_in_words' do
    it 'returns words because the datetime is within 24 hours' do
      datetime = Time.now - 5.hours
      helper.little_time_ago_in_words(datetime).should == '約5時間前'
    end

    it 'returns datetime string because the datetime is without 24 hours' do
      datetime = Time.now - 24.hours
      helper.little_time_ago_in_words(datetime).should == datetime.strftime('%Y/%m/%d %H:%M:%S')
    end
  end
end
