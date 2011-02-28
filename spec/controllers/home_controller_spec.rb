# coding: utf-8

require 'spec_helper'

describe HomeController do

  describe '#index' do

    context "user login" do
      let(:user) { Factory.create(:user) }

      before do
        user.confirm!
        sign_in user
      end

      it 'redirects to home_path' do
        get :index
        response.should redirect_to home_path
      end
    end

    context "user not login" do
      before do
        Factory.create(:bookmark)
      end

      it 'renders index template' do
        get :index
        response.should render_template("home/index")
      end
    end
  end

  describe '#public_timeline' do
    before do
      Factory.create(:bookmark, :url => 'http://twitter.com/bojovs1')
      Factory.create(:bookmark, :url => 'http://twitter.com/bojovs2')
      Factory.create(:bookmark, :url => 'http://twitter.com/bojovs3', :private => true)
    end

    it 'returns public bookmarks' do
      get :public_timeline
      assigns(:bookmarks).count.should == 2
    end
  end
end
