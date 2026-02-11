require 'test_helper'

class TarjetaCreditosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tarjeta_credito = tarjeta_creditos(:one)
  end

  test "should get index" do
    get tarjeta_creditos_url
    assert_response :success
  end

  test "should get new" do
    get new_tarjeta_credito_url
    assert_response :success
  end

  test "should create tarjeta_credito" do
    assert_difference('TarjetaCredito.count') do
      post tarjeta_creditos_url, params: { tarjeta_credito: { actualizado: @tarjeta_credito.actualizado, actualizado_por: @tarjeta_credito.actualizado_por, creado: @tarjeta_credito.creado, creado_por: @tarjeta_credito.creado_por, estado: @tarjeta_credito.estado, nombre: @tarjeta_credito.nombre } }
    end

    assert_redirected_to tarjeta_credito_url(TarjetaCredito.last)
  end

  test "should show tarjeta_credito" do
    get tarjeta_credito_url(@tarjeta_credito)
    assert_response :success
  end

  test "should get edit" do
    get edit_tarjeta_credito_url(@tarjeta_credito)
    assert_response :success
  end

  test "should update tarjeta_credito" do
    patch tarjeta_credito_url(@tarjeta_credito), params: { tarjeta_credito: { actualizado: @tarjeta_credito.actualizado, actualizado_por: @tarjeta_credito.actualizado_por, creado: @tarjeta_credito.creado, creado_por: @tarjeta_credito.creado_por, estado: @tarjeta_credito.estado, nombre: @tarjeta_credito.nombre } }
    assert_redirected_to tarjeta_credito_url(@tarjeta_credito)
  end

  test "should destroy tarjeta_credito" do
    assert_difference('TarjetaCredito.count', -1) do
      delete tarjeta_credito_url(@tarjeta_credito)
    end

    assert_redirected_to tarjeta_creditos_url
  end
end
