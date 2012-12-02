require 'test_helper'

class NetworkControllerTest < ActionController::TestCase
  test "should get pingmap" do
    get :pingmap
    assert_response :success
  end

  test "should get traceroute" do
    get :traceroute
    assert_response :success
  end

  test "should get ping" do
    get :ping
    assert_response :success
  end

end
