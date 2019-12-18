# frozen_string_literal: true

require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
  end

  test 'password resets' do
    # リセット用メールアドレス入力フォームにアクセス
    get new_password_reset_path
    assert_template 'password_resets/new'
    # 無効なメールアドレスを入力
    post password_resets_path, params: {
      password_reset: { email: '' }
    }
    assert_not flash.empty?
    assert_template 'password_resets/new'
    # 有効なメールアドレスを入力
    post password_resets_path, params: {
      password_reset: { email: @user.email }
    }
    assert_not @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    # edit_password_reset_urlへのGET
    # 登録されていないメールアドレス
    user = assigns(:user)
    get edit_password_reset_path(user.reset_token, email: '')
    assert_redirected_to root_url
    # 無効なユーザ
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)
    # 有効なメールアドレスと無効なトークン
    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url
    # 有効なメールアドレスと有効なトークン
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select 'input[name=email][type=hidden][value=?]', user.email
    # パスワードリセットフォームからの送信
    # 無効なパスワードと確認用パスワード
    patch password_reset_path(user.reset_token), params: {
      email: user.email,
      user: {
        password: 'aaaaaaa',
        password_confirmation: 'bbbbbbb'
      }
    }
    assert_select 'div#error_explanation'
    # パスワードが空
    patch password_reset_path(user.reset_token), params: {
      email: user.email,
      user: {
        password: '',
        password_confirmation: ''
      }
    }
    assert_select 'div#error_explanation'
    # 有効なパスワードと確認用パスワード
    patch password_reset_path(user.reset_token), params: {
      email: user.email,
      user: {
        password: 'hogehoge',
        password_confirmation: 'hogehoge'
      }
    }
    assert is_logged_in?
    assert_not flash.empty?
    assert_nil user.reload.reset_digest
    assert_redirected_to user
  end

  test 'expired token' do
    get new_password_reset_path
    post password_resets_path, params: {
      password_reset: { email: @user.email }
    }

    @user = assigns(:user)
    @user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(@user.reset_token), params: {
      email: @user.email,
      user: {
        password: 'hogehoge',
        password_confirmation: 'hogehoge'
      }
    }
    assert_response :redirect
    follow_redirect!
    assert_match 'Password reset has expired', response.body
  end
end
