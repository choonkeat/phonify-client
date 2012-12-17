require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.create(:user) }
  let(:origin_phone) { { number: "91234567", country: "es" } }
  let(:service_phone){ { number: "77555", country: "es"} }
  let(:origin_phone_msisdn) { "349123456789" }
  let(:service_phone_msisdn){ "+3477555" }
  it 'should return nil for monthly_subscription' do
    user.monthly_subscription.should == nil
  end
  describe '#create_monthly_subscription' do
    it "should call api" do
      lambda {
        user.create_monthly_subscription(origin: origin_phone, service: service_phone)
      }.should change(Phonify::Phone, :count)
    end
    it "should call api" do
      lambda {
        user.create_monthly_subscription(origin: origin_phone_msisdn, service: service_phone_msisdn)
      }.should change(Phonify::Phone, :count)
    end
  end
  describe 'with monthly_subscription' do
    before(:each) do
      lambda {
        user.create_monthly_subscription(origin: origin_phone, service: service_phone)
      }.should change(Phonify::Phone, :count)
    end
    it 'should retrieve phone object with token attribute' do
      user.monthly_subscription.phone.class.should == Phonify::Phone
      user.monthly_subscription.phone.token.should_not == nil
    end
    it 'should list messages' do
      msg, *others = user.monthly_subscription.messages.to_a
      msg.class.should == Phonify::Message
      msg.remote_attributes.should_not be_blank
      msg.token.should_not == nil
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
        msg.token.should_not == nil
      end
    end
  end

end
