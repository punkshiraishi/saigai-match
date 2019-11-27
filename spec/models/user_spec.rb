require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with a name, email, and password" do
    user = User.new(
      name: "Mikite",
      email: "mikite@gmail.com",
      password: "mikitepassword"
    )
    expect(user).to be_valid
  end

  it "is invalid without a name" do
    user = User.new(name: nil)
    user.valid?
    expect(user.errors[:name]).to include("can't be blank")
  end

  it "is invalid without email" do
    user = User.new(email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  it "is invalid with wrong email" do
    user = User.new(email: "aaa@aaa")
    user.valid?
    expect(user.errors[:email]).to include("is invalid")
  end

  it "is invalid without password" do
    user = User.new(password: nil)
    user.valid?
    expect(user.errors[:password]).to include("can't be blank")
  end

  it "is invalid with short password" do
    user = User.new(password: "aaaaa")
    user.valid?
    expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
  end

  it "is invalid with a duplicate email address" do
    User.create(
      name: "mikite",
      email: "mikite@gmail.com",
      password: "mikitepass"
    )
    other_user = User.new(
      name: "yuma",
      email: "mikite@gmail.com",
      password: "yumapass"
    )
    other_user.valid?
    expect(other_user.errors[:email]).to include("has already been taken")
  end
end
