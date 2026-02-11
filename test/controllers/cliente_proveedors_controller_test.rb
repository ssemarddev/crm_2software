require 'test_helper'

class ClienteProveedorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cliente_proveedor = cliente_proveedors(:one)
  end

  test "should get index" do
    get cliente_proveedors_url
    assert_response :success
  end

  test "should get new" do
    get new_cliente_proveedor_url
    assert_response :success
  end

  test "should create cliente_proveedor" do
    assert_difference('ClienteProveedor.count') do
      post cliente_proveedors_url, params: { cliente_proveedor: { Destino: @cliente_proveedor.Destino, Estado: @cliente_proveedor.Estado, Fax: @cliente_proveedor.Fax, Moneda: @cliente_proveedor.Moneda, Nombre: @cliente_proveedor.Nombre, Porcentaje_Comision: @cliente_proveedor.Porcentaje_Comision, Tipo: @cliente_proveedor.Tipo, Tipo_Cambio: @cliente_proveedor.Tipo_Cambio, actualizado: @cliente_proveedor.actualizado, actualizado_por: @cliente_proveedor.actualizado_por, creado: @cliente_proveedor.creado, creado_por: @cliente_proveedor.creado_por } }
    end

    assert_redirected_to cliente_proveedor_url(ClienteProveedor.last)
  end

  test "should show cliente_proveedor" do
    get cliente_proveedor_url(@cliente_proveedor)
    assert_response :success
  end

  test "should get edit" do
    get edit_cliente_proveedor_url(@cliente_proveedor)
    assert_response :success
  end

  test "should update cliente_proveedor" do
    patch cliente_proveedor_url(@cliente_proveedor), params: { cliente_proveedor: { Destino: @cliente_proveedor.Destino, Estado: @cliente_proveedor.Estado, Fax: @cliente_proveedor.Fax, Moneda: @cliente_proveedor.Moneda, Nombre: @cliente_proveedor.Nombre, Porcentaje_Comision: @cliente_proveedor.Porcentaje_Comision, Tipo: @cliente_proveedor.Tipo, Tipo_Cambio: @cliente_proveedor.Tipo_Cambio, actualizado: @cliente_proveedor.actualizado, actualizado_por: @cliente_proveedor.actualizado_por, creado: @cliente_proveedor.creado, creado_por: @cliente_proveedor.creado_por } }
    assert_redirected_to cliente_proveedor_url(@cliente_proveedor)
  end

  test "should destroy cliente_proveedor" do
    assert_difference('ClienteProveedor.count', -1) do
      delete cliente_proveedor_url(@cliente_proveedor)
    end

    assert_redirected_to cliente_proveedors_url
  end
end
