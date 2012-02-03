require 'test_helper'

class VentaControllerTest < ActionController::TestCase
  setup do
    @ventum = venta(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:venta)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ventum" do
    assert_difference('Ventum.count') do
      post :create, ventum: @ventum.attributes
    end

    assert_redirected_to ventum_path(assigns(:ventum))
  end

  test "should show ventum" do
    get :show, id: @ventum.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ventum.to_param
    assert_response :success
  end

  test "should update ventum" do
    put :update, id: @ventum.to_param, ventum: @ventum.attributes
    assert_redirected_to ventum_path(assigns(:ventum))
  end

  test "should destroy ventum" do
    assert_difference('Ventum.count', -1) do
      delete :destroy, id: @ventum.to_param
    end

    assert_redirected_to venta_path
  end
end
