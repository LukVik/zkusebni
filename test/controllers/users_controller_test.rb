require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new signup page" do
    get signup_path
    assert_response :success
    assert_select 'title', text: full_title('Sign up')
  end

end
