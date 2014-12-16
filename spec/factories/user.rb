FactoryGirl.define do
  factory :user do
    email {"user#{rand(9999)}@exampl.com"}
    password "password"
    confirmed_at { Time.now }
  end
end
