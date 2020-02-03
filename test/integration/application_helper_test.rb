# frozen_string_literal: true

require 'test_helper'

class ApplicationHelperTest < ActionDispatch::IntegrationTest
  test 'full title helper test' do
    base_title = 'Ruby on Rails Tutorial Sample App'
    assert_equal full_title, base_title
    page_title = %w[Home About Help Contact]
    page_title.each do |page_title|
      assert_equal full_title(page_title), "#{page_title} | #{base_title}"
    end
  end
end
