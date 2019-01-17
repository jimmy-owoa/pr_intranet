require "application_system_test_case"

class Admin::SectionsTest < ApplicationSystemTestCase
  setup do
    @admin_section = admin_sections(:one)
  end

  test "visiting the index" do
    visit admin_sections_url
    assert_selector "h1", text: "Admin/Sections"
  end

  test "creating a Section" do
    visit admin_sections_url
    click_on "New Admin/Section"

    fill_in "Description", with: @admin_section.description
    fill_in "Location", with: @admin_section.location
    fill_in "Title", with: @admin_section.title
    fill_in "Url", with: @admin_section.url
    click_on "Create Section"

    assert_text "Section was successfully created"
    click_on "Back"
  end

  test "updating a Section" do
    visit admin_sections_url
    click_on "Edit", match: :first

    fill_in "Description", with: @admin_section.description
    fill_in "Location", with: @admin_section.location
    fill_in "Title", with: @admin_section.title
    fill_in "Url", with: @admin_section.url
    click_on "Update Section"

    assert_text "Section was successfully updated"
    click_on "Back"
  end

  test "destroying a Section" do
    visit admin_sections_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Section was successfully destroyed"
  end
end
