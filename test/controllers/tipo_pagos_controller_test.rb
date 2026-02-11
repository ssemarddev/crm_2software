require 'test_helper'

class TipoPagosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tipo_pago = tipo_pagos(:one)
  end

  test "should get index" do
    get tipo_pagos_url
    assert_response :success
  end

  test "should get new" do
    get new_tipo_pago_url
    assert_response :success
  end

  test "should create tipo_pago" do
    assert_difference('TipoPago.count') do
      post tipo_pagos_url, params: { tipo_pago: { Destino: @tipo_pago.Destino, Estado: @tipo_pago.Estado, Moneda: @tipo_pago.Moneda, Nombre: @tipo_pago.Nombre, Porcentaje_Comision: @tipo_pago.Porcentaje_Comision, Tipo_Cambio: @tipo_pago.Tipo_Cambio, actualizado: @tipo_pago.actualizado, actualizado_por: @tipo_pago.actualizado_por, creado: @tipo_pago.creado, creado_por: @tipo_pago.creado_por } }
    end

    assert_redirected_to tipo_pago_url(TipoPago.last)
  end

  test "should show tipo_pago" do
    get tipo_pago_url(@tipo_pago)
    assert_response :success
  end

  test "should get edit" do
    get edit_tipo_pago_url(@tipo_pago)
    assert_response :success
  end

  test "should update tipo_pago" do
    patch tipo_pago_url(@tipo_pago), params: { tipo_pago: { Destino: @tipo_pago.Destino, Estado: @tipo_pago.Estado, Moneda: @tipo_pago.Moneda, Nombre: @tipo_pago.Nombre, Porcentaje_Comision: @tipo_pago.Porcentaje_Comision, Tipo_Cambio: @tipo_pago.Tipo_Cambio, actualizado: @tipo_pago.actualizado, actualizado_por: @tipo_pago.actualizado_por, creado: @tipo_pago.creado, creado_por: @tipo_pago.creado_por } }
    assert_redirected_to tipo_pago_url(@tipo_pago)
  end

  test "should destroy tipo_pago" do
    assert_difference('TipoPago.count', -1) do
      delete tipo_pago_url(@tipo_pago)
    end

    assert_redirected_to tipo_pagos_url
  end
end
