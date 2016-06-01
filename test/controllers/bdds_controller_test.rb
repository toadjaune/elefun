require 'test_helper'

class BddsControllerTest < ActionController::TestCase
  setup do
    @bdd = bdds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bdds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bdd" do
    assert_difference('Bdd.count') do
      post :create, bdd: {  }
    end

    assert_redirected_to bdd_path(assigns(:bdd))
  end

  test "should show bdd" do
    get :show, id: @bdd
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @bdd
    assert_response :success
  end

  test "should update bdd" do
    patch :update, id: @bdd, bdd: {  }
    assert_redirected_to bdd_path(assigns(:bdd))
  end

  test "should destroy bdd" do
    assert_difference('Bdd.count', -1) do
      delete :destroy, id: @bdd
    end

    assert_redirected_to bdds_path
  end
end
