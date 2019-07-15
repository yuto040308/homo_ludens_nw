require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get users_show_url
    assert_response :success
  end

  test "should get edit" do
    get users_edit_url
    assert_response :success
  end

  test "should get update" do
    get users_update_url
    assert_response :success
  end

  test "should get destroy" do
    get users_destroy_url
    assert_response :success
  end

  test "should get event" do
    get users_event_url
    assert_response :success
  end

  test "should get admin" do
    get users_admin_url
    assert_response :success
  end

  test "should get admin_index" do
    get users_admin_index_url
    assert_response :success
  end

  test "should get admin_show" do
    get users_admin_show_url
    assert_response :success
  end

end
