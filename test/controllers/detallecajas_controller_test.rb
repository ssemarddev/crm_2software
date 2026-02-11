require 'test_helper'

class DetallecajasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @detallecaja = detallecajas(:one)
  end

  test "should get index" do
    get detallecajas_url
    assert_response :success
  end

  test "should get new" do
    get new_detallecaja_url
    assert_response :success
  end

  test "should create detallecaja" do
    assert_difference('Detallecaja.count') do
      post detallecajas_url, params: { detallecaja: { actualizado: @detallecaja.actualizado, actualizado_por: @detallecaja.actualizado_por, caja_id: @detallecaja.caja_id, cantidad: @detallecaja.cantidad, creado: @detallecaja.creado, creado_por: @detallecaja.creado_por, razon: @detallecaja.razon, status: @detallecaja.status, tipo: @detallecaja.tipo } }
    end

    assert_redirected_to detallecaja_url(Detallecaja.last)
  end

  test "should show detallecaja" do
    get detallecaja_url(@detallecaja)
    assert_response :success
  end

  test "should get edit" do
    get edit_detallecaja_url(@detallecaja)
    assert_response :success
  end

  test "should update detallecaja" do
    patch detallecaja_url(@detallecaja), params: { detallecaja: { actualizado: @detallecaja.actualizado, actualizado_por: @detallecaja.actualizado_por, caja_id: @detallecaja.caja_id, cantidad: @detallecaja.cantidad, creado: @detallecaja.creado, creado_por: @detallecaja.creado_por, razon: @detallecaja.razon, status: @detallecaja.status, tipo: @detallecaja.tipo } }
    assert_redirected_to detallecaja_url(@detallecaja)
  end

  test "should destroy detallecaja" do
    assert_difference('Detallecaja.count', -1) do
      delete detallecaja_url(@detallecaja)
    end

    assert_redirected_to detallecajas_url
  end
end
