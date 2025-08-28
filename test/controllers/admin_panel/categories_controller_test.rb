require "test_helper"

class AdminPanel::CategoriesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_panel_categories_index_url
    assert_response :success
  end
end
