require 'test_helper'

class FichiersControllerTest < ActionController::TestCase
  setup do
    @fichier = fichiers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fichiers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fichier" do
    assert_difference('Fichier.count') do
      post :create, fichier: { mooc_id: @fichier.mooc_id, nom: @fichier.nom }
    end

    assert_redirected_to fichier_path(assigns(:fichier))
  end

  test "should show fichier" do
    get :show, id: @fichier
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @fichier
    assert_response :success
  end

  test "should update fichier" do
    patch :update, id: @fichier, fichier: { mooc_id: @fichier.mooc_id, nom: @fichier.nom }
    assert_redirected_to fichier_path(assigns(:fichier))
  end

  test "should destroy fichier" do
    assert_difference('Fichier.count', -1) do
      delete :destroy, id: @fichier
    end

    assert_redirected_to fichiers_path
  end
end
