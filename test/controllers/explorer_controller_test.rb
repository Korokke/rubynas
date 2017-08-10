require 'test_helper'

class ExplorerControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get explorer_show_url
    assert_response :success
  end

  test "should get _panel_actions" do
    get explorer__panel_actions_url
    assert_response :success
  end

end
