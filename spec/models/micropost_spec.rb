# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Micropost, type: :model do
  before do
    @user = User.create(
      name: 'Mikite',
      email: 'mikite@gmail.com',
      password: 'mikitepassword'
    )
  end

  it 'is valid with user_id, a content' do
    micropost = @user.microposts.create(
      content: 'test'
    )
    expect(micropost).to be_valid
  end

  it 'is invalid without a content' do
    micropost = @user.microposts.create(
      content: ''
    )
    expect(micropost.errors[:content]).to include "can't be blank"
  end

  it 'is invalid with a long content' do
    micropost = @user.microposts.create(
      content: 'a' * 141
    )
    expect(micropost.errors[:content]).to include('is too long (maximum is 140 characters)')
  end
end
