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
end
