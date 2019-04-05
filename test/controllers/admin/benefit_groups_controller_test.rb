require 'test_helper'

class Admin::BenefitGroupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @benefit_group = admin_benefit_groups(:one)
  end

  test "should get index" do
    get admin_benefit_groups_url
    assert_response :success
  end

  test "should get new" do
    get new_admin_benefit_group_url
    assert_response :success
  end

  test "should create admin_benefit_group" do
    assert_difference('Admin::BenefitGroup.count') do
      post admin_benefit_groups_url, params: { admin_benefit_group: {  } }
    end

    assert_redirected_to admin_benefit_group_url(Admin::BenefitGroup.last)
  end

  test "should show admin_benefit_group" do
    get admin_benefit_group_url(@benefit_group)
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_benefit_group_url(@benefit_group)
    assert_response :success
  end

  test "should update admin_benefit_group" do
    patch admin_benefit_group_url(@benefit_group), params: { admin_benefit_group: {  } }
    assert_redirected_to admin_benefit_group_url(@benefit_group)
  end

  test "should destroy admin_benefit_group" do
    assert_difference('Admin::BenefitGroup.count', -1) do
      delete admin_benefit_group_url(@benefit_group)
    end

    assert_redirected_to admin_benefit_groups_url
  end
end
