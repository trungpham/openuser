require 'factory_girl'

FactoryGirl.define do
  sequence :uid do |n|
    "#{n}"
  end

  sequence :name do |n|
    "name#{n}"
  end

  sequence :email do |n|
  "email#{n}@example.com"
  end

  factory :user do
    name {FactoryGirl.generate(:name)}
    email {FactoryGirl.generate(:email)}
    password 'please'
  end
  factory :email do
    address FactoryGirl.generate(:email)
    is_verified true
    trait :unverified do
      is_verified false
    end
  end
  factory :identity do
    _email = FactoryGirl.generate(:email)
    _name = FactoryGirl.generate(:name)
    provider 'facebook'
    uid FactoryGirl.generate(:uid)
    email :address => _email, :is_verified => true
    info { {'email' => _email, 'name' => _name} }
    user :factory => :user, :email => _email, :password => 'please', :name => _name
  end

  factory :unverified_identity, :class => :identity do
    _email = FactoryGirl.generate(:email)
    _name = FactoryGirl.generate(:name)
    provider 'facebook'
    uid FactoryGirl.generate(:uid)
    email :address => _email, :is_verified => false
    info { {'email' => _email, 'name' => _name} }
  end
end
