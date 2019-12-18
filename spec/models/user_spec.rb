# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with a name, email, and password' do
    expect(FactoryBot.build(:user)).to be_valid
  end

  it 'is invalid without a name' do
    user = User.new(name: nil)
    user.valid?
    expect(user.errors[:name]).to include("can't be blank")
  end

  it 'is invalid with a long name' do
    user = User.new(name: 'a' * 51)
    user.valid?
    expect(user.errors[:name]).to include('is too long (maximum is 50 characters)')
  end

  it 'is invalid without email' do
    user = User.new(email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  it 'is invalid with a long email' do
    user = User.new(email: 'a' * 244 + '@example.com')
    user.valid?
    expect(user.errors[:email]).to include('is too long (maximum is 255 characters)')
  end

  it 'is valid with valid addresses' do
    user = User.new(
      name: 'Mikite',
      password: 'mikitepassword'
    )
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      user.email = valid_address
      user.valid?
      expect(user).to be_valid
    end
  end

  it 'is invalid with invalid addresses' do
    user = User.new(
      name: 'Mikite',
      password: 'mikitepassword'
    )
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com foo@baz..com]
    invalid_addresses.each do |invalid_address|
      user.email = invalid_address
      user.valid?
      expect(user.errors[:email]).to include('is invalid')
    end
  end

  it 'is invalid without password' do
    user = User.new(password: nil)
    user.valid?
    expect(user.errors[:password]).to include("can't be blank")
  end

  it 'is invalid with a short password' do
    user = User.new(password: 'aaaaa')
    user.valid?
    expect(user.errors[:password]).to include('is too short (minimum is 6 characters)')
  end

  it 'is invalid with a duplicate email address' do
    User.create(
      name: 'mikite',
      email: 'mikite@gmail.com',
      password: 'mikitepass'
    )
    other_user = User.new(
      name: 'yuma',
      email: 'mikite@gmail.com',
      password: 'yumapass'
    )
    other_user.valid?
    expect(other_user.errors[:email]).to include('has already been taken')
  end

  it 'has a downcase email address' do
    mixed_case_email = 'MIKITE@gmail.com'
    user = User.new(
      name: 'mikite',
      email: mixed_case_email,
      password: 'mikipass'
    )
    user.save
    user.reload
    expect(user.reload.email).to eq(mixed_case_email.downcase)
  end
end
