require 'test_helper'

class UserProfileControllerTest < ActionController::TestCase
  test "should get sms" do
    get :sms
    assert_response :success
  end

end
