require 'test_helper'

class DomainUserGroupPermissionsControllerTest < ActionController::TestCase
  setup do
    @domain_user_group_permission = domain_user_group_permissions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:domain_user_group_permissions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create domain_user_group_permission" do
    assert_difference('DomainUserGroupPermission.count') do
      post :create, :domain_user_group_permission => @domain_user_group_permission.attributes
    end

    assert_redirected_to domain_user_group_permission_path(assigns(:domain_user_group_permission))
  end

  test "should show domain_user_group_permission" do
    get :show, :id => @domain_user_group_permission.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @domain_user_group_permission.to_param
    assert_response :success
  end

  test "should update domain_user_group_permission" do
    put :update, :id => @domain_user_group_permission.to_param, :domain_user_group_permission => @domain_user_group_permission.attributes
    assert_redirected_to domain_user_group_permission_path(assigns(:domain_user_group_permission))
  end

  test "should destroy domain_user_group_permission" do
    assert_difference('DomainUserGroupPermission.count', -1) do
      delete :destroy, :id => @domain_user_group_permission.to_param
    end

    assert_redirected_to domain_user_group_permissions_path
  end
end
