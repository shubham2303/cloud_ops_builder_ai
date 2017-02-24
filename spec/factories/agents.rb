FactoryGirl.define do
  factory :agent do
  	sequence(:name) { |n| "Agent #{n}" }
    sequence(:phone) { |n| "92" + ("#{n}"*8)[0,8] }
  end
end
