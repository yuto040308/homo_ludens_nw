require 'test_helper'

class PlaysControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get plays_index_url
    assert_response :success
  end

  test "should get show" do
    get plays_show_url
    assert_response :success
  end

  test "should get admin_index" do
    get plays_admin_index_url
    assert_response :success
  end

  test "should get admin_show" do
    get plays_admin_show_url
    assert_response :success
  end

  test "should get admin_new" do
    get plays_admin_new_url
    assert_response :success
  end

  test "should get admin_create" do
    get plays_admin_create_url
    assert_response :success
  end

  test "should get admin_edit" do
    get plays_admin_edit_url
    assert_response :success
  end

  test "should get admin_update" do
    get plays_admin_update_url
    assert_response :success
  end

  test "should get admin_destroy" do
    get plays_admin_destroy_url
    assert_response :success
  end

end
