FactoryBot.define do
  factory :employee do
    association :company

    sequence(:name) { |n| "Employee#{n}" }
    
    email { "#{name.gsub(/\s+/, '.').downcase}@#{company.name.gsub(/\s+/, '').downcase}.com" }
    
    picture { "picture.jpg" }
  end
end