require 'test_helper'

class EditControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:lukas)
  end

  test "should get edit user page" do
  get edit_user_path(@user.id)
  assert_response :success
  assert_select 'title', text: full_title('Edit user')
  end
end