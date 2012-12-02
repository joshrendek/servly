require 'test_helper'

class ServerServicesControllerTest < ActionController::TestCase
  setup do
    @server_service = server_services(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:server_services)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create server_service" do
    assert_difference('ServerService.count') do
      post :create, :server_service => @server_service.attributes
    end

    assert_redirected_to server_service_path(assigns(:server_service))
  end

  test "should show server_service" do
    get :show, :id => @server_service.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @server_service.to_param
    assert_response :success
  end

  test "should update server_service" do
    put :update, :id => @server_service.to_param, :server_service => @server_service.attributes
    assert_redirected_to server_service_path(assigns(:server_service))
  end

  test "should destroy server_service" do
    assert_difference('ServerService.count', -1) do
      delete :destroy, :id => @server_service.to_param
    end

    assert_redirected_to server_services_path
  end
end
