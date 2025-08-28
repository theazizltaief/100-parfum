require "test_helper"

class ParfumsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get parfums_index_url
    assert_response :success
  end

  test "should get show" do
    get parfums_show_url
    assert_response :success
  end

  test "should get new" do
    get parfums_new_url
    assert_response :success
  end

  test "should get create" do
    get parfums_create_url
    assert_response :success
  end
end
