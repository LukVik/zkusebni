# frozen_string_literal: true

require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:lukas)
  end

  test 'unsuccessful edit' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_select 'h1', text: 'Update your profile'
    patch user_path(@user), params: { user: { name: '',
                                              email: 'foo@invalid',
                                              password: 'foo',
                                              password_confirmation: 'bar' } }
    assert_select 'div.alert', text: 'The form contains 4 errors.'
  end

  # Write a test to make sure that friendly forwarding only forwards to the given
  # URL the first time. On subsequent login attempts, the forwarding URL should revert
  # to the default (i.e., the profile page). Hint: Add to the test in Listing 10.29 by
  # checking for the right value of session[:forwarding_url].

  test 'successful edit with friendly forwarding only forwards to the given URL the first time' do
    get edit_user_path(@user)

    # Checks if the URL was stored in the session.
    assert session[:forwarding_url]

    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)

    # Checks if the URL was deleted from the session.
    assert session[:forwarding_url].nil?

    name  = 'Foo Bar'
    email = 'foo@bar.com'
    patch user_path(@user), params: { user: { name: name,
                                              email: email,
                                              password: '',
                                              password_confirmation: '' } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end
end
