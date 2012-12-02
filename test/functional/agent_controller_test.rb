require 'test_helper'

class AgentControllerTest < ActionController::TestCase
  test "should get installer" do
    get :installer
    assert_response :success
  end

end
