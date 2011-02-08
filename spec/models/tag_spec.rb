# coding: utf-8

require 'spec_helper'

describe Tag do

  describe 'validation' do
    it 'is not valid when name is over 32 characters' do
      status = Factory.build(:tag, :name => "t#{'o'*20} l#{'o'*20}ng!!!")
      status.should_not be_valid
    end

    it 'is not valid when phonetic_name is over 32 characters' do
      status = Factory.build(:tag, :phonetic_name => "t#{'o'*20} l#{'o'*20}ng!!!")
      status.should_not be_valid
    end

    it 'is not valid when about is over 150 characters' do
      status = Factory.build(:tag, :about => "t#{'o'*100} l#{'o'*50}ng!!!")
      status.should_not be_valid
    end

    it 'is not valid when user_id is blank' do
      status = Factory.build(:tag, :user_id => '')
      status.should_not be_valid
    end

    it 'is not valid when name is blank' do
      status = Factory.build(:tag, :name => '')
      status.should_not be_valid
    end
  end

  describe '.to_json' do
    let(:user) { Factory.create(:user) }
    let(:tag) { Factory.create(:tag, :user_id => @user.id) }

    it 'returns json' do
      tags = Tag.all.only(:name, :phonetic_name).to_a
      Tag.to_json(user).should == tags.to_json
    end
  end
end
