# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Relationship, type: :model do
  before do
    @user = User.create(
      name: 'Mikite',
      email: 'mikite@gmail.com',
      password: 'mikitepassword'
    )
    @other_user = User.create(
      name: 'Yuma',
      email: 'yuma@gmail.com',
      password: 'yumapassword'
    )
  end

  it 'is valid with a follower_id and follower_id' do
    relationship = Relationship.new(
      follower_id: @user.id,
      followed_id: @other_user.id
    )

    relationship.valid?

    expect(relationship).to be_valid
  end

  it 'raise error with duplicate records' do
    Relationship.create(
      follower_id: @user.id,
      followed_id: @other_user.id
    )

    expect do
      Relationship.create(
        follower_id: @user.id,
        followed_id: @other_user.id
      )
    end.to raise_error(ActiveRecord::RecordNotUnique)
  end
end
