require 'test_helper'

class Frontend::MenusControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get frontend_menus_index_url
    assert_response :success
  end

  test "should get new" do
    get frontend_menus_new_url
    assert_response :success
  end

  test "should get edit" do
    get frontend_menus_edit_url
    assert_response :success
  end

  test "should get show" do
    get frontend_menus_show_url
    assert_response :success
  end

end
