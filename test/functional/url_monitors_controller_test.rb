require 'test_helper'

class UrlMonitorsControllerTest < ActionController::TestCase
  setup do
    @url_monitor = url_monitors(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:url_monitors)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create url_monitor" do
    assert_difference('UrlMonitor.count') do
      post :create, :url_monitor => @url_monitor.attributes
    end

    assert_redirected_to url_monitor_path(assigns(:url_monitor))
  end

  test "should show url_monitor" do
    get :show, :id => @url_monitor.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @url_monitor.to_param
    assert_response :success
  end

  test "should update url_monitor" do
    put :update, :id => @url_monitor.to_param, :url_monitor => @url_monitor.attributes
    assert_redirected_to url_monitor_path(assigns(:url_monitor))
  end

  test "should destroy url_monitor" do
    assert_difference('UrlMonitor.count', -1) do
      delete :destroy, :id => @url_monitor.to_param
    end

    assert_redirected_to url_monitors_path
  end
end
