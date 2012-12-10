require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.create(:user) }
  let(:origin_phone) { { number: "91234567", country: "es" } }
  let(:service_phone){ { number: "77555", country: "es"} }
  describe '#create_monthly_subscription' do
    it "should call api" do
      lambda {
        user.create_monthly_subscription(origin: origin_phone, service: service_phone)
      }.should change(Phonify::Phone, :count)
    end
  end
  describe 'with monthly_subscription' do
    before(:each) do
      lambda {
        user.create_monthly_subscription(origin: origin_phone, service: service_phone)
      }.should change(Phonify::Phone, :count)
    end
    it 'should list messages' do
      msg, *others = user.monthly_subscription.messages.to_a
      msg.class.should == Phonify::Message
      msg.remote_attributes.should_not be_blank
    end
    it 'should list local messages (empty)' do
      user.monthly_subscription.messages(:local).to_a.should == []
    end
    it 'should allow monthly_subscription.messages.create' do
      lambda {
        user.monthly_subscription.messages.create(message: "hello world")
      }.should change(Phonify::Message, :count)
    end
    describe 'with created message' do
      before(:each) do
        user.monthly_subscription.messages.create(message: "hello world")
      end
      it 'should list local messages' do
        msg, *others = user.monthly_subscription.messages(:local).to_a
        msg.class.should == Phonify::Message
        msg.remote_attributes.should be_blank
      end
    end
  end

end
