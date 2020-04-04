# frozen_string_literal: true

require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:lukas)
  end

  test 'login with invalid information' do
    get login_path
    assert_select 'h1', 'Log in'
    post login_path, params: { session: { email: '', password: '' } }
    assert_equal 'Invalid email/password combination', flash[:danger]
    assert_select 'h1', 'Log in'
    get root_path
    assert flash.empty?
    assert_not response.body.include? 'Invalid email/password combination'
  end

  test 'successful login, with valid information' do
    post login_path, params: { session: { email: @user.email, password: 'password' } }
    assert_equal 'Welcome to the Sample App!', flash[:success]
    assert_redirected_to user_path(@user.id)
    follow_redirect!
  end

  test 'successful login, check proper user menu links, followed by logout' do
    post login_path, params: { session: { email: @user.email,
                                          password: 'password' } }
    assert is_logged_in?
    assert_equal 'Welcome to the Sample App!', flash[:success]
    assert_redirected_to @user
    follow_redirect!
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
end