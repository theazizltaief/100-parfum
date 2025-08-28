require "test_helper"

class AdminPanel::ProductsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_panel_products_index_url
    assert_response :success
  end
end
