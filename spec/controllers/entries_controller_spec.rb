# coding: utf-8

require 'spec_helper'

describe EntriesController do

  describe '#show' do
    context "with valid parameters" do
      let(:entry) { Factory.create(:entry) }

      it 'renders show template' do
        params = {:id => entry.id}
        get :show, params
        response.should render_template("entries/show")
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
