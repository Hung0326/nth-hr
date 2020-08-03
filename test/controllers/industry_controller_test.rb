require 'test_helper'

class IndustryControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get industry_index_url
    assert_response :success
  end

end
