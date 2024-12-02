require "test_helper"

class GamesControllerTest < ActionDispatch::IntegrationTest

  # test "the truth" do
  #   assert true
  # end

  test "should get new" do
    get games_new_url
    assert_response :success

end
