FactoryGirl.define do

  factory :user do
    sequence(:name) {|n| "Person #{n}"}
    sequence(:phone_number) {|n| "%5d" % n }
  end

end
