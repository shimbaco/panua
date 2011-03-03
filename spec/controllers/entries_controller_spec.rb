# coding: utf-8

require 'spec_helper'

describe EntriesController do

  describe '#show' do
    context "with valid parameters" do
      let(:entry) { Factory.create(:entry) }
      let(:params) { {:id => entry.id} }

      it 'renders show template' do
        get :show, params
        response.should render_template("entries/show")
      end

      it 'gets parent comments' do
        comment1 = Factory.create(:comment)
        comment2 = Factory.create(:comment)
        entry.comments << comment1
        entry.comments << comment2
        comment1.children << comment2
        get :show, params
        assigns(:comments).count.should == 1
      end
    end

    context "with invalid parameters" do
      it 'returns responce 404 when id is wrong' do
        params = {:id => 'aaaaaaaaaaaaaaaaaaaaaaaa'}
        get :show, params
        response.code.should == '404'
      end
    end
  end
end
