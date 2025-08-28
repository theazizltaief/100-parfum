require "test_helper"

class VitrineControllerTest < ActionDispatch::IntegrationTest
  test "should get accueil" do
    get vitrine_accueil_url
    assert_response :success
  end
end
