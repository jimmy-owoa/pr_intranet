require 'test_helper'

class Admin::ProfilesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_profiles_index_url
    assert_response :success
  end

  test "should get new" do
    get admin_profiles_new_url
    assert_response :success
  end

  test "should get edit" do
    get admin_profiles_edit_url
    assert_response :success
  end

  test "should get show" do
    get admin_profiles_show_url
    assert_response :success
  end

  test "should get delete" do
    get admin_profiles_delete_url
    assert_response :success
  end

end
