require 'test_helper'

class Sapi::UserControllerTest < ActionController::TestCase
  test "should get authorize" do
    get :authorize
    assert_response :success
  end

end
