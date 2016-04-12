require 'test_helper'

class JokesControllerTest < ActionController::TestCase
  test "should get make_allright" do
    get :make_allright
    assert_response :success
  end

  test "should get overcome_laziness" do
    get :overcome_laziness
    assert_response :success
  end

  test "should get become_a_cat" do
    get :become_a_cat
    assert_response :success
  end

end
