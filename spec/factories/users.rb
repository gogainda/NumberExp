# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user, class: User do
    sequence :email
    password { generate :string }
  end

  factory :facebook_user, class: User do
    facebook_uid '20012479'
  end
end
