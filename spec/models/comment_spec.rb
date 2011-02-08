# coding: utf-8

require 'spec_helper'

describe Comment do

  describe 'validation' do
    it 'is not valid when body is over 1000 characters' do
      status = Factory.build(:comment, :body => "t#{'o'*500} l#{'o'*1000}ng!!!")
      status.should_not be_valid
    end

    it 'is not valid when body is blank' do
      status = Factory.build(:comment, :body => '')
      status.should_not be_valid
    end
  end
end
