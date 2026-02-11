require 'test_helper'

class DocumentoPagosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @documento_pago = documento_pagos(:one)
  end

  test "should get index" do
    get documento_pagos_url
    assert_response :success
  end

  test "should get new" do
    get new_documento_pago_url
    assert_response :success
  end

  test "should create documento_pago" do
    assert_difference('DocumentoPago.count') do
      post documento_pagos_url, params: { documento_pago: { ClienteProveedor_id: @documento_pago.ClienteProveedor_id, Deuda: @documento_pago.Deuda, Documento_id: @documento_pago.Documento_id, Estado: @documento_pago.Estado, Interes: @documento_pago.Interes, Mora: @documento_pago.Mora, Nombre_Targeta: @documento_pago.Nombre_Targeta, Numero_Tarjeta: @documento_pago.Numero_Tarjeta, Pagado: @documento_pago.Pagado, Pago_Efectivo: @documento_pago.Pago_Efectivo, Pago_Tarjeta: @documento_pago.Pago_Tarjeta, Tarjeta_id: @documento_pago.Tarjeta_id, Tipo_Documento: @documento_pago.Tipo_Documento, Total_Pagado: @documento_pago.Total_Pagado, actualizado: @documento_pago.actualizado, actualizado_por: @documento_pago.actualizado_por, creado: @documento_pago.creado, creado_por: @documento_pago.creado_por } }
    end

    assert_redirected_to documento_pago_url(DocumentoPago.last)
  end

  test "should show documento_pago" do
    get documento_pago_url(@documento_pago)
    assert_response :success
  end

  test "should get edit" do
    get edit_documento_pago_url(@documento_pago)
    assert_response :success
  end

  test "should update documento_pago" do
    patch documento_pago_url(@documento_pago), params: { documento_pago: { ClienteProveedor_id: @documento_pago.ClienteProveedor_id, Deuda: @documento_pago.Deuda, Documento_id: @documento_pago.Documento_id, Estado: @documento_pago.Estado, Interes: @documento_pago.Interes, Mora: @documento_pago.Mora, Nombre_Targeta: @documento_pago.Nombre_Targeta, Numero_Tarjeta: @documento_pago.Numero_Tarjeta, Pagado: @documento_pago.Pagado, Pago_Efectivo: @documento_pago.Pago_Efectivo, Pago_Tarjeta: @documento_pago.Pago_Tarjeta, Tarjeta_id: @documento_pago.Tarjeta_id, Tipo_Documento: @documento_pago.Tipo_Documento, Total_Pagado: @documento_pago.Total_Pagado, actualizado: @documento_pago.actualizado, actualizado_por: @documento_pago.actualizado_por, creado: @documento_pago.creado, creado_por: @documento_pago.creado_por } }
    assert_redirected_to documento_pago_url(@documento_pago)
  end

  test "should destroy documento_pago" do
    assert_difference('DocumentoPago.count', -1) do
      delete documento_pago_url(@documento_pago)
    end

    assert_redirected_to documento_pagos_url
  end
end
