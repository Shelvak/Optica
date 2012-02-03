require 'test_helper'

class HistorialsControllerTest < ActionController::TestCase
  setup do
    @historial = historials(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:historials)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create historial" do
    assert_difference('Historial.count') do
      post :create, historial: @historial.attributes
    end

    assert_redirected_to historial_path(assigns(:historial))
  end

  test "should show historial" do
    get :show, id: @historial.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @historial.to_param
    assert_response :success
  end

  test "should update historial" do
    put :update, id: @historial.to_param, historial: @historial.attributes
    assert_redirected_to historial_path(assigns(:historial))
  end

  test "should destroy historial" do
    assert_difference('Historial.count', -1) do
      delete :destroy, id: @historial.to_param
    end

    assert_redirected_to historials_path
  end
end
