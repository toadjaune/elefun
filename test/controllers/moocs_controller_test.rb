require 'test_helper'

class MoocsControllerTest < ActionController::TestCase
  setup do
    @mooc = moocs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:moocs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mooc" do
    assert_difference('Mooc.count') do
      post :create, mooc: { auteur: @mooc.auteur, bdd_id: @mooc.bdd_id, id_cours: @mooc.id_cours, periode: @mooc.periode }
    end

    assert_redirected_to mooc_path(assigns(:mooc))
  end

  test "should show mooc" do
    get :show, id: @mooc
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @mooc
    assert_response :success
  end

  test "should update mooc" do
    patch :update, id: @mooc, mooc: { auteur: @mooc.auteur, bdd_id: @mooc.bdd_id, id_cours: @mooc.id_cours, periode: @mooc.periode }
    assert_redirected_to mooc_path(assigns(:mooc))
  end

  test "should destroy mooc" do
    assert_difference('Mooc.count', -1) do
      delete :destroy, id: @mooc
    end

    assert_redirected_to moocs_path
  end
end
