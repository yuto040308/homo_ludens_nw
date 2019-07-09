require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get events_index_url
    assert_response :success
  end

  test "should get show" do
    get events_show_url
    assert_response :success
  end

  test "should get join" do
    get events_join_url
    assert_response :success
  end

  test "should get complete" do
    get events_complete_url
    assert_response :success
  end

  test "should get new" do
    get events_new_url
    assert_response :success
  end

  test "should get create" do
    get events_create_url
    assert_response :success
  end

  test "should get edit" do
    get events_edit_url
    assert_response :success
  end

  test "should get update" do
    get events_update_url
    assert_response :success
  end

  test "should get destroy" do
    get events_destroy_url
    assert_response :success
  end

  test "should get cansel" do
    get events_cansel_url
    assert_response :success
  end

  test "should get admin_index" do
    get events_admin_index_url
    assert_response :success
  end

  test "should get admin_show" do
    get events_admin_show_url
    assert_response :success
  end

  test "should get admin_destroy" do
    get events_admin_destroy_url
    assert_response :success
  end

  test "should get admin_accept" do
    get events_admin_accept_url
    assert_response :success
  end

end
