class User < ActiveRecord::Base
  has_one :monthly_subscription, as: "owner", class_name: "Phonify::Subscription", conditions: { campaign_id: Phonify.config.monthly }
  attr_accessible :name, :phone_number
end
