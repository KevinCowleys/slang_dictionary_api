FactoryBot.define do
  factory :user do
    username { 'MyString' }
    email { 'user@fake.com' }
    is_admin { false }
  end
end
