require 'spec_helper'

describe User do

  describe 'FactoryGirl :user and :admin' do
    it "should work (baseline sanity check)" do
      user = FactoryGirl.create(:user)
      user.should be_valid
    end
  end

end
