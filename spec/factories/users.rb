# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'Mikite' }
    email { 'mikite@gmail.com' }
    password { 'mikitepassword' }
  end
end
