# frozen_string_literal: true

require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test 'unsuccessful signup create new user' do
    get signup_path
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name: '',
                                         email: '',
                                         password: '',
                                         password_confirmation: '' } }
    end
    assert_select 'h1', text: 'Sign up'
    assert_select 'div.field_with_errors'
    User.new.errors.full_messages.each do |message|
      assert_select 'div#error_explanation li', text: message
    end
    assert_select 'div.alert-danger'
  end

  test 'error messages display and are accurate' do
    get signup_path
    user = User.new(name: '', email: '', password: '', password_confirmation: '')
    user.valid?
    assert user.errors.messages.values_at(:name, :email, :password_confirmation, :password)
  end
end
