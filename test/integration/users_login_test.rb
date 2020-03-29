# frozen_string_literal: true

require 'test_helper'


class UsersLoginTest < ActionDispatch::IntegrationTest

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

  test 'login successful' do
    get login_path
    post login_path, params: { session: { email: 'user@example.com', passsword: 'foobar' } }
  end
  end