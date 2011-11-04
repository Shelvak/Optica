require 'test_helper'

class RecetesControllerTest < ActionController::TestCase
  setup do
    @recete = recetes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:recetes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create recete" do
    assert_difference('Recete.count') do
      post :create, recete: @recete.attributes
    end

    assert_redirected_to recete_path(assigns(:recete))
  end

  test "should show recete" do
    get :show, id: @recete.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @recete.to_param
    assert_response :success
  end

  test "should update recete" do
    put :update, id: @recete.to_param, recete: @recete.attributes
    assert_redirected_to recete_path(assigns(:recete))
  end

  test "should destroy recete" do
    assert_difference('Recete.count', -1) do
      delete :destroy, id: @recete.to_param
    end

    assert_redirected_to recetes_path
  end
end
