require 'test_helper'

class EstadortackingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @estadortacking = estadortackings(:one)
  end

  test "should get index" do
    get estadortackings_url
    assert_response :success
  end

  test "should get new" do
    get new_estadortacking_url
    assert_response :success
  end

  test "should create estadortacking" do
    assert_difference('Estadortacking.count') do
      post estadortackings_url, params: { estadortacking: { actualizado: @estadortacking.actualizado, actualizado_por: @estadortacking.actualizado_por, comentario: @estadortacking.comentario, creado: @estadortacking.creado, creado_por: @estadortacking.creado_por, estado_id: @estadortacking.estado_id, status: @estadortacking.status, tracking_id: @estadortacking.tracking_id } }
    end

    assert_redirected_to estadortacking_url(Estadortacking.last)
  end

  test "should show estadortacking" do
    get estadortacking_url(@estadortacking)
    assert_response :success
  end

  test "should get edit" do
    get edit_estadortacking_url(@estadortacking)
    assert_response :success
  end

  test "should update estadortacking" do
    patch estadortacking_url(@estadortacking), params: { estadortacking: { actualizado: @estadortacking.actualizado, actualizado_por: @estadortacking.actualizado_por, comentario: @estadortacking.comentario, creado: @estadortacking.creado, creado_por: @estadortacking.creado_por, estado_id: @estadortacking.estado_id, status: @estadortacking.status, tracking_id: @estadortacking.tracking_id } }
    assert_redirected_to estadortacking_url(@estadortacking)
  end

  test "should destroy estadortacking" do
    assert_difference('Estadortacking.count', -1) do
      delete estadortacking_url(@estadortacking)
    end

    assert_redirected_to estadortackings_url
  end
end
