FactoryGirl.define do
  factory :token do
  	agent { FactoryGirl.create(:agent) }
  end
end
