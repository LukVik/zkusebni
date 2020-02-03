# frozen_string_literal: true

require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test 'sitelinks test' do
    get root_path
    assert response.body.include?(full_title('Home'))
    assert_select 'h1', text: 'Welcome to the Sample App'
    assert_select '.container' do
      assert_select 'a[href=?]#logo', root_path
      assert_select 'nav' do
        assert_select 'ul.nav.navbar-nav.navbar-right' do
          assert_select 'li a[href=?]', root_path
          assert_select 'li a[href=?]', help_path
        end
      end
    end
    assert_select 'footer' do
      assert_select 'li a[href=?]', about_path
      assert_select 'li a[href=?]', contact_path
      assert_select 'li a[href=?]', 'http://news.railstutorial.org/', text: "News"
    end
    get contact_path
    assert_select 'title', full_title('Contact')
    assert response.body.include?(full_title('Contact'))
    get signup_path
    assert_select 'title', full_title('Sign up')
    assert response.body.include?(full_title('Sign up'))
  end
end
