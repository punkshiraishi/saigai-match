# frozen_string_literal: true

require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test 'unsuccessful edit' do
    log_in_as @user
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: '', email: 'foo@invalid', password: 'foo', password_confirmation: 'bar' } }
    assert_template 'users/edit'
    assert_select 'div.alert', 'The form contains 4 errors.'
  end

  test 'successful edit' do
    log_in_as @user
    get edit_user_path(@user)
    assert_template 'users/edit'
    name_changed = 'Changed'
    email_changed = 'changed@example.com'
    patch user_path(@user), params: { user: { name: name_changed, email: email_changed, password: '', password_confirmation: '' } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name_changed, @user.name
    assert_equal email_changed, @user.email
  end

  test 'successful edit with friendry forwarding' do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name_changed = 'Changed'
    email_changed = 'changed@example.com'
    patch user_path(@user), params: { user: { name: name_changed, email: email_changed, password: '', password_confirmation: '' } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name_changed, @user.name
    assert_equal email_changed, @user.email
  end

  test 'should redirect edit when logged in as wrong user' do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test 'should redirect update when logged in as wrong user' do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name, email: @user } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test 'should not redirect back when login' do
    get edit_user_url(@user)
    assert_equal session[:forwarding_url], edit_user_url(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    assert_nil session[:forwarding_url]
  end
end
