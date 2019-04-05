require "application_system_test_case"

class Admin::BenefitGroupsTest < ApplicationSystemTestCase
  setup do
    @benefit_group = admin_benefit_groups(:one)
  end

  test "visiting the index" do
    visit admin_benefit_groups_url
    assert_selector "h1", text: "Admin/Benefit Groups"
  end

  test "creating a Benefit group" do
    visit admin_benefit_groups_url
    click_on "New Admin/Benefit Group"

    click_on "Create Benefit group"

    assert_text "Benefit group was successfully created"
    click_on "Back"
  end

  test "updating a Benefit group" do
    visit admin_benefit_groups_url
    click_on "Edit", match: :first

    click_on "Update Benefit group"

    assert_text "Benefit group was successfully updated"
    click_on "Back"
  end

  test "destroying a Benefit group" do
    visit admin_benefit_groups_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Benefit group was successfully destroyed"
  end
end
