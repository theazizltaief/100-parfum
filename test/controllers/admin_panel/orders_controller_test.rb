require "test_helper"

class AdminPanel::OrdersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_panel_orders_index_url
    assert_response :success
  end
end
